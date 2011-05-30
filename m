Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1E3PNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:13:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52686 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1E3PNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=SltigP1U2lWwOWJAuVGcQselDTISrNyjP2GG2XHysQk2jETx7hLWS9j+HEM3edccVg
         oGmQb52d7K4io5TaJ/4GS6Ll+i0UA9xF3k+kNJIrNb2/5/uwEMc+ApKvwrPlzraIlpW/
         r9T4KyNkp4wVLeSu2Jh/G2JDP/4klEPjjcEaM=
MIME-Version: 1.0
In-Reply-To: <20110530130949.GB13494@lst.de>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
 <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com> <20110530130949.GB13494@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 30 May 2011 17:13:22 +0200
X-Google-Sender-Auth: KsnWiFHBltF0cFAat6NoGuyrNbE
Message-ID: <BANLkTikdJcNPv4CV4nLuyuPtAYpCR1cp0Q@mail.gmail.com>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 3:09 PM, Christoph Hellwig <hch@lst.de> wrote:
> Given that we pretty well tested and working code that's used in lots
> of production setups my vote is for taking it as-is unless someone can
> actually show a prototype for a nicely working user/kernel split.

As far as I know such a user/kernel split has been implemented in both
IET and SCST and is working fine in both of these projects.

And here is another issue that still hasn't been resolved yet:
http://marc.info/?l=linux-scsi&m=129707890023739&w=2.

Bart.
