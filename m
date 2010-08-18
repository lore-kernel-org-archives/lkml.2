Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0HRPM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:12:59 -0400
Received: from n3a.bullet.mail.ac4.yahoo.com ([76.13.13.66]:25613 "HELO
	n3a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952Ab0HRPM6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:12:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 121146.78525.bm@omp115.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zBfffoYj6lh3x54fiU0sAhmyru5IahcVp79V8nF7U85WCmxEPmAHmySDu146kRd27uMajgfeYWk4z7aQwqAIpOOjJ0rR75/FXFrtRZMNxxtHngLN+7HuvbkdX/W31BJmHf+/9mU5wk4EmsjpvL2X9D+kdCLwwZzS6L9vfOzmFt0=;
Message-ID: <976203.51076.qm@web111913.mail.gq1.yahoo.com>
X-YMail-OSG: 9ZESxloVM1k4dMiTgbSfvNFuuhCdsjf47UcxLNSJMtw.2gb
 0XXU_7UBHvLnVa0MoNZHYABMrfaLUEfDA2Hf_nlaLFbmwfQFpWEZqyAbLx9q
 OpODg7bvqkxbnnk.MGNO0d1FnDZsZ4vbOsRuZbf0h4.TpAoVlCX2P4bg4YBT
 VL0ZzGifFMGe.MUT.2Fa912QbOG2qKlhWASho0GlGF_dXh4EKCl6nU.exNxx
 br8cbtbQ1cWclaUB8pwrx5BUa7hpuYBJbJ11pnmeE2WH.GPwJyCnIwm8YcGp
 .mhGcnLGtBYXCD.dr0G4A_v1dCXk_zleCqD2MC3kDv8WCeuUaqE5Rt6Tdt1X
 btDP1Y0pyqXcanXg-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 18 Aug 2010 08:12:56 -0700 (PDT)
From: Chetan Loke <generationgnu@yahoo.com>
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
To: Vladislav Bolkhovitin <vst@vlnb.net>,
        James Bottomley <James.Bottomley@suse.de>
Cc: scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, pls ignore my first question:

I was trying to access https://lwn.net/Articles/399148/

But I just read:
http://lwn.net/Articles/400589/

Chetan

--- On Wed, 8/18/10, Chetan Loke <generationgnu@yahoo.com> wrote:

> From: Chetan Loke <generationgnu@yahoo.com>
> Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
> To: "Vladislav Bolkhovitin" <vst@vlnb.net>, "James Bottomley" <James.Bottomley@suse.de>
> Cc: "scst-devel" <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Date: Wednesday, August 18, 2010, 2:58 PM
> Hello James and others,
> 
> --- On Tue, 8/17/10, James Bottomley <James.Bottomley@suse.de>
> wrote:
> 
> > From: James Bottomley <James.Bottomley@suse.de>
> > Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
> > To: "Vladislav Bolkhovitin" <vst@vlnb.net>
> > Cc: "scst-devel" <scst-devel@lists.sourceforge.net>,
> linux-kernel@vger.kernel.org,
> linux-scsi@vger.kernel.org
> > Date: Tuesday, August 17, 2010, 8:30 PM
> > On Mon, 2010-08-16 at 20:20 +0400,
> > Vladislav Bolkhovitin wrote:
> > > Hello James,
> > > 
> > > Could you comment rumors that decision about
> future
> > Linux SCSI target 
> > > subsystem is done as well as other related
> rumors:
> > 
> > If this is related to LSF, the notes on the I/O track
> are
> > here:
> > 
> > http://lwn.net/Articles/400491/
> 
> 
> During the open panel, my question was really specific - 
> 
> Q) What is the future of a SCSI-target subsystem in linux.
> Which 
>    target engine/subsystem can we expect?
> 
> Your answer) There is place for only 1 target-subsystem in
> the Linux scsi stack and in the LSF summit the decision was
> taken to merge LIO. Has that
> decision changed since the summit?
> 
> As a scst-user what I would like to understand is, what was
> that decision based on? Because the LSF summit was 'small by
> invitation' only summit. The notes don't give us an insight
> on the selection criteria/merits etc.
> 
> 
> > 
> > > 3. I have heard you said "Vlad wasn't comfortable
> in
> > handing up the 
> > > control to the maintainers ... (this is how
> kernel.org
> > works)." I have 
> > > no idea what you meant. I have never been asked
> about
> > anything like 
> > > that, so I couldn't say anyhow that I'm not
> > comfortable with anything. 
> > > Could you clarify that?
> > > 
> 
> 3) above is something that I emailed Vlad and the scst
> community based on our offline conversation after the open
> panel. If SCST really has licensing issues then I will
> personally stop using SCST. Since Vlad hasn't
> expressed any concerns on the above and neither have you
> commented on it, is it safe to assume that the licensing
> requirement is a non-issue?
> 
> 
> Chetan Loke
> 
> 
> 
>       
> 
> 
> ------------------------------------------------------------------------------
> This SF.net email is sponsored by 
> 
> Make an app they can't live without
> Enter the BlackBerry Developer Challenge
> http://p.sf.net/sfu/RIM-dev2dev 
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 


      

