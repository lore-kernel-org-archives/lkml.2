Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1EXQay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:30:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45320 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1EXQax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v+VlPdD6/yLBQTbXDh6BenMXJsLOQe626y3Av5mGy2ERc5Zs/uBx/DyKTVBTZvxaVY
         tT9Qw4I6iW9Zv/eABM63rtxJRtHHXUfXhYAlcyGLrc98FZOFB1UNxKE6jINzJyqwUVdm
         AH5pJpjk6I/D+s04FEshIEHLiypMuhW9Wa1JU=
MIME-Version: 1.0
In-Reply-To: <1306226815.28926.322.camel@vkoul-udesk3>
References: <fd5b04cbce5c1051dee3faf0719f6db3ee706e60.1306226016.git.viresh.kumar@st.com>
	<1306226815.28926.322.camel@vkoul-udesk3>
Date: Tue, 24 May 2011 09:30:51 -0700
Message-ID: <BANLkTikTEEgu_uq_ee=aZW+G7gfJaPrrWQ@mail.gmail.com>
Subject: Re: [PATCH resend] dmaengine/dw_dmac: Update maintainer-ship
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        armando.visconti@st.com, viresh.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 1:46 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Tue, 2011-05-24 at 14:04 +0530, Viresh Kumar wrote:
>> Nobody is currently maintaining dw_dmac. We are using dw_dmac for SPEAr13xx and
>> are currently maintaining it. After discussing with Vinod, sending this patch to
>> update maintainer-ship of dw_dmac.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  MAINTAINERS                |    7 +++++++
>>  drivers/dma/dw_dmac.c      |    2 ++
>>  drivers/dma/dw_dmac_regs.h |    1 +
>>  include/linux/dw_dmac.h    |    1 +
>>  4 files changed, 11 insertions(+), 0 deletions(-)
> Am okay if Havard is...

Hard to say based on the diffstat alone, but the patch I found in the
archives looks sane, so it's ok with me. Hopefully it's the same one
;-)

Havard
