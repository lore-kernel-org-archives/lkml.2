Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0HRO6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:58:23 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:28231 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751995Ab0HRO6U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:58:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 196626.32766.bm@omp105.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KPhptJHPEX+Sk82hJfmnO7CSyeqivQEU0jO+oBAEPHrz/WZTQ5X089fkYhmxRNWpm0x0i/ZpQdh8qsapYjtepOKvcpv5D3GE9Cf8oD6lAm+O4FA2bG3jjMfABA5SKJiQlIKp+OQOepmMUU3s7dSVTjo/yCbO+9OVN+aoGNbkojk=;
Message-ID: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
X-YMail-OSG: iF3dVCIVM1nQ_smaG0GXhsy6_4gkvn3ftb5gCfPODbygYar
 tgLY602APByo3lJejJ05ouUXe1C1jpq.ux5_r_eVCbhcCfN9Qss9gOncFD8G
 Oz4ciNV_CPG.64MbWN3lk1GUR6hZ15nsloBuNdKEw2rYKqDFz9muT1KmJiGl
 jaVe1kZtNacSoMIKN7jFR6GrYp26giVfHl18n2UgfgN8BhD5hK7N92PNZqba
 RIlItHrfxspDjRsGpn9uPkabqq3Zw30J0r1COhsdQQ74an9eTeTnk.fDdb2N
 A0bx44iQhBHDZqMrl4s6Hy57ko01U.Pw8TGRnfqzUvIphz1Fx.G7lcKIv2xc
 t2bRsLkuPLs296Ec-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 18 Aug 2010 07:58:19 -0700 (PDT)
From: Chetan Loke <generationgnu@yahoo.com>
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
To: Vladislav Bolkhovitin <vst@vlnb.net>,
        James Bottomley <James.Bottomley@suse.de>
Cc: scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello James and others,

--- On Tue, 8/17/10, James Bottomley <James.Bottomley@suse.de> wrote:

> From: James Bottomley <James.Bottomley@suse.de>
> Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
> To: "Vladislav Bolkhovitin" <vst@vlnb.net>
> Cc: "scst-devel" <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Date: Tuesday, August 17, 2010, 8:30 PM
> On Mon, 2010-08-16 at 20:20 +0400,
> Vladislav Bolkhovitin wrote:
> > Hello James,
> > 
> > Could you comment rumors that decision about future
> Linux SCSI target 
> > subsystem is done as well as other related rumors:
> 
> If this is related to LSF, the notes on the I/O track are
> here:
> 
> http://lwn.net/Articles/400491/


During the open panel, my question was really specific - 

Q) What is the future of a SCSI-target subsystem in linux. Which 
   target engine/subsystem can we expect?

Your answer) There is place for only 1 target-subsystem in the Linux scsi stack and in the LSF summit the decision was taken to merge LIO. Has that
decision changed since the summit?

As a scst-user what I would like to understand is, what was that decision based on? Because the LSF summit was 'small by invitation' only summit. The notes don't give us an insight on the selection criteria/merits etc.


> 
> > 3. I have heard you said "Vlad wasn't comfortable in
> handing up the 
> > control to the maintainers ... (this is how kernel.org
> works)." I have 
> > no idea what you meant. I have never been asked about
> anything like 
> > that, so I couldn't say anyhow that I'm not
> comfortable with anything. 
> > Could you clarify that?
> > 

3) above is something that I emailed Vlad and the scst community based on our offline conversation after the open panel. If SCST really has licensing issues then I will personally stop using SCST. Since Vlad hasn't
expressed any concerns on the above and neither have you commented on it, is it safe to assume that the licensing requirement is a non-issue?


Chetan Loke



      

