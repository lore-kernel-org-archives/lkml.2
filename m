Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1KXUmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 15:42:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab1KXUmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 15:42:22 -0500
Message-ID: <4ECEAC1F.4070609@redhat.com>
Date: Thu, 24 Nov 2011 18:42:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
CC: Greg KH <gregkh@suse.de>, Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] Staging: cx25821: Clean up patch series
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com> <20111022081941.GA5443@suse.de> <4EA3A7ED.8090404@redhat.com> <20111119142856.3c619022@inspire>
In-Reply-To: <20111119142856.3c619022@inspire>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-11-2011 04:28, Leonid V. Fedorenchik escreveu:
> On Sun, 23 Oct 2011 07:36:45 +0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> Em 22-10-2011 10:19, Greg KH escreveu:
>>> On Sat, Oct 22, 2011 at 01:43:20PM +0800, Leonid V. Fedorenchik wrote:
>>>> This patch series fixes some style issues in drivers/staging/cx25821
>>>> Mostly I was hoping to improve readability and fix some issues found by
>>>> checkpatch.pl script.
>>>
>>> These are for Mauro to take through his tree.
>>
>> Yes. I'll put them on my queue.
> 
> I didn't find this patch series in any of linux, staging, linux-media,
> and media-next trees. Since you moved driver cx25821 out of staging,
> do you want me to resend this patch series rebased on top of media-next?

No need. I'll apply it with:

$ more `quilt next` | sed s,drivers/staging/cx25821/,drivers/media/video/cx25821/, >a && mv a `quilt next` 

> Or I missed it somewhere and you applied it?

I was too busy those days due to KS and then LinuxCon Brazil. I'm handling your
patches today.

Regards,
Mauro
