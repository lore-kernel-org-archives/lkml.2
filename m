Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab2ASOEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:04:02 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2ASOD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:03:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120119084836.GA29477@boyd>
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
	<4F16E4BC.5080100@gmail.com>
	<526922120.05125@eyou.net>
	<12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
	<20120119084836.GA29477@boyd>
Date: Thu, 19 Jan 2012 08:03:57 -0600
X-Google-Sender-Auth: 8ra1fI4i6jbs_X0bkdFotrOENok
Message-ID: <CANT6BaOqXwut5iA2ADO_2avW2kCSV0WL_6=3Vv1zdFNXrnXjPA@mail.gmail.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
From: Dustin Kirkland <dustin.kirkland@gazzang.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Li Wang <liwang@nudt.edu.cn>, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 2:48 AM, Tyler Hicks <tyhicks@canonical.com> wrote:
> On 2012-01-19 09:44:36, Li Wang wrote:
>>
>>
>> Hi,
>>   Thanks Cong Wang for the kind reminding regarding the patch format.
>
> The commit message still needs some work. But there's no need to drag
> out the process for a fix like this, so I'll rewrite the commit message
> and reply to this email with the cleaned up version. Let me know if you
> have any problems with that. You'll still be credited as the author.
>
> For future kernel patches, please see "15) The canonical patch format"
> of Documentation/SubmittingPatches and "5.4: PATCH FORMATTING AND
> CHANGELOGS" of Documentation/development-process/5.Posting for more
> information on how the commit message should be written.
>
> Also, your email came across in base64 encoding. I'm not sure of the
> reason for that or how to fix it.
>
>>   We did notice that the total_remaining_zeroes need be revised as well,
>> and the start_offset_in_page, num_bytes need not be revised (always smaller
>
> Yes, size_t will work fine, as Linus confirmed.
>
>> than PAGE_CACHE_SIZE, even the huge page size is supported,
>> the 4G page size is not present in the current world?)
>> but we forget to include the revision for total_remaining_zeroes, so here comes the patch.
>
> I really appreciate the patch - thanks!

Tyler,

Is this the problem behind our long standing
tor-download-on-ecryptfs-hangs-cpu bug?
 * https://bugs.launchpad.net/ecryptfs/+bug/431975

-- 
:-Dustin

Dustin Kirkland
Chief Architect
Gazzang, Inc.
www.gazzang.com
