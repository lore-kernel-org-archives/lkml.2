Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1BRRte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:49:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1BRRtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:49:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: regression 2.6.38-rc4 -> 2.6.38-rc5 suspend fails
Date: Fri, 18 Feb 2011 18:49:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Guillaume Chazarain <guichaz@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20110217163300.GA7988@gamma.logic.tuwien.ac.at> <201102172309.26106.rwys@fuw.edu.pl> <20110218025601.GA30118@gamma.logic.tuwien.ac.at>
In-Reply-To: <20110218025601.GA30118@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181849.17589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 18, 2011, Norbert Preining wrote:
> On Do, 17 Feb 2011, R. J. Wysocki wrote:
> > > [  187.431895] sd 0:0:0:0: [sda] Stopping disk
> > > [  187.480078] tpm_tis 00:0a: Operation Timed out
> > > [  187.480095] legacy_suspend(): pnp_bus_suspend+0x0/0x6a returns -62
> > > [  187.480101] PM: Device 00:0a failed to suspend: error -62
> 
> > What happens if you revert commit 9b29050 (tpm_tis: Use timeouts returned from TPM)?
> 
> Reverting this commit the laptop suspends fine again.

Stefan, Rajiv, the above commit causes a suspend regression to appear for
Norbert.  Care to have a look?

Rafael
