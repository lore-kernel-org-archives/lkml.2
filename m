Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab1DMQDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:03:45 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47836 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758198Ab1DMQDm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dUMt/1R7vbpGXffltoy9IVpzqpA2n028P7Ii11BJGdgQOdktS53DEvS7HKwxjfZhwQ
         RFeAuqBB2aKePAK3hOs2pmoYoo2jddy+elxZULGwdNar0F/2I37PXQwl/GyTSUGIFlju
         B3CyM3BQ9gUEPTLADrctIRqtNmgnUiqznfSQg=
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C8B3CBD@dbde02.ent.ti.com>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
	<f1ff3f2888725a1e03541e0be5c0880f0591aea2.1302031487.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB593024C8B3C9F@dbde02.ent.ti.com>
	<BANLkTi=j=Dp015ZsU44DH3p1s_XdxvAX8Q@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024C8B3CBD@dbde02.ent.ti.com>
Date: Wed, 13 Apr 2011 12:03:39 -0400
Message-ID: <BANLkTi=OCqFTFMyfA3iF_yqQi2Pmxm5V+Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 11:42 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> On Wed, Apr 13, 2011 at 20:52:05, Ben Gardiner wrote:
>> I understand "check for pdata to be NULL."  If you think it is the
>> better option I'd be happy to implement it but I don't understand how
>> to implement "let each board choose whether it needs recovery."
>
> This is done by just setting has_pfunc = 1 in the
> davinci_i2c_platform_data defined in the board file.

Ok -- now I get it, thanks. I spin a V2 shortly.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
