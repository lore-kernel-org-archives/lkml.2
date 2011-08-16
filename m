Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1HPHcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:32:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51064 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1HPHcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:32:54 -0400
MIME-Version: 1.0
In-Reply-To: <1313451542-79316-1-git-send-email-jeffbrown@android.com>
References: <1313451542-79316-1-git-send-email-jeffbrown@android.com>
Date: Tue, 16 Aug 2011 09:32:52 +0200
Message-ID: <CAN+gG=ETNmP4Xy7NhxLpkaqAog4T1PQ5eCdXF11SvR2Ce+DtHA@mail.gmail.com>
Subject: Re: [PATCH] hid-debug: Show application usage for each collection.
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: jeffbrown@android.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        rydberg@euromail.se
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 01:39,  <jeffbrown@android.com> wrote:
> From: Jeff Brown <jeffbrown@android.com>

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@logitech.com>

>
> Signed-off-by: jeffbrown@android.com
> ---
>  drivers/hid/hid-debug.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
> index bae4874..9a243ca 100644
> --- a/drivers/hid/hid-debug.c
> +++ b/drivers/hid/hid-debug.c
> @@ -450,6 +450,11 @@ void hid_dump_field(struct hid_field *field, int n, struct seq_file *f) {
>                seq_printf(f, "Logical(");
>                hid_resolv_usage(field->logical, f); seq_printf(f, ")\n");
>        }
> +       if (field->application) {
> +               tab(n, f);
> +               seq_printf(f, "Application(");
> +               hid_resolv_usage(field->application, f); seq_printf(f, ")\n");
> +       }
>        tab(n, f); seq_printf(f, "Usage(%d)\n", field->maxusage);
>        for (j = 0; j < field->maxusage; j++) {
>                tab(n+2, f); hid_resolv_usage(field->usage[j].hid, f); seq_printf(f, "\n");
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
