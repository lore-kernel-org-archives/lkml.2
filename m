Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1HXS6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:58:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1HXS6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:58:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+gG=ETNmP4Xy7NhxLpkaqAog4T1PQ5eCdXF11SvR2Ce+DtHA@mail.gmail.com>
References: <1313451542-79316-1-git-send-email-jeffbrown@android.com> <CAN+gG=ETNmP4Xy7NhxLpkaqAog4T1PQ5eCdXF11SvR2Ce+DtHA@mail.gmail.com>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Wed, 24 Aug 2011 11:58:03 -0700
Message-ID: <CAMu+ixjg71wR9_WLqEihGtud0=SuRdnc=4nB43F+pxjNpdEKug@mail.gmail.com>
Subject: Re: [PATCH] hid-debug: Show application usage for each collection.
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rydberg@euromail.se
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 12:32 AM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Tue, Aug 16, 2011 at 01:39,  <jeffbrown@android.com> wrote:
>> From: Jeff Brown <jeffbrown@android.com>
>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@logitech.com>

Just a friendly ping.

Do I need to do anything more on this, or on the other patch to hid-multitouch?

>> Signed-off-by: jeffbrown@android.com
>> ---
>>  drivers/hid/hid-debug.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
>> index bae4874..9a243ca 100644
>> --- a/drivers/hid/hid-debug.c
>> +++ b/drivers/hid/hid-debug.c
>> @@ -450,6 +450,11 @@ void hid_dump_field(struct hid_field *field, int n, struct seq_file *f) {
>>                seq_printf(f, "Logical(");
>>                hid_resolv_usage(field->logical, f); seq_printf(f, ")\n");
>>        }
>> +       if (field->application) {
>> +               tab(n, f);
>> +               seq_printf(f, "Application(");
>> +               hid_resolv_usage(field->application, f); seq_printf(f, ")\n");
>> +       }
>>        tab(n, f); seq_printf(f, "Usage(%d)\n", field->maxusage);
>>        for (j = 0; j < field->maxusage; j++) {
>>                tab(n+2, f); hid_resolv_usage(field->usage[j].hid, f); seq_printf(f, "\n");
>> --
>> 1.7.0.4
>>
>> --
