Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab2JYTRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:17:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36537 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083Ab2JYTRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:17:05 -0400
Message-ID: <5089902E.9020204@deserettechnology.com>
Date: Thu, 25 Oct 2012 13:17:02 -0600
From: Jeff Cook <jeff@deserettechnology.com>
Reply-To: jeff@deserettechnology.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Anderson Lizardo <anderson.lizardo@openbossa.org>, gustavo@padovan.org
CC: marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for BCM20702A0 [0b05, 17b5]
References: <5087B517.9090703@deserettechnology.com> <CAJdJm_NrmfU17aQDmO0hbihV673Of0iFnLqk4=-sPh=g44eixA@mail.gmail.com>
In-Reply-To: <CAJdJm_NrmfU17aQDmO0hbihV673Of0iFnLqk4=-sPh=g44eixA@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 06:20 AM, Anderson Lizardo wrote:
> Hi Jeff,
> 
> On Wed, Oct 24, 2012 at 5:29 AM, Jeff Cook <jeff@deserettechnology.com> wrote:
>> Hello all,
>>
>> Please see included patch. First-time submitter so let me know if I did
>> something wrong.
> 
> Just one more suggestion (adding to Gustavo's comments), you may want to read:
> 
> http://www.kernel.org/doc/Documentation/SubmittingPatches
> 
> Specially sections 12 and 15.

Thanks for the help everyone. I did skim SubmittingPatches prior to
submission, but dropped off before sections 12 and 15; the information
seemed outdated since it made no mention of git by the time I stopped
reading (around section 9 or so), so I looked elsewhere.

I will resubmit according to the information in Section 15. Do I need to
add something like "try 2" to the patch's subject line, or is it okay
without that?
