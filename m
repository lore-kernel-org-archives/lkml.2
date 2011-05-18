Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab1ERTLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:11:21 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:51701 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933607Ab1ERTLT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:11:19 -0400
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: Milton Miller <miltonm@bga.com>, Hitoshi Mitake <h.mitake@gmail.com>,
        "Sam Ravnborg" <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>,
        "Desai, Kashyap" <Kashyap.Desai@lsi.com>,
        "Prakash, Sathya" <Sathya.Prakash@lsi.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <matthew@wil.cx>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux scsi dev" <linux-scsi@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        linux powerpc dev <linuxppc-dev@lists.ozlabs.org>,
        linux pci <linux-pci@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Date: Wed, 18 May 2011 13:11:16 -0600
Subject: RE: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Thread-Topic: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Thread-Index: AcwVieU5LTm0CgdjRU+hkbX1+XUGcQABUgnw
Message-ID: <4565AEA676113A449269C2F3A549520F80BE7F37@cosmail03.lsi.com>
References: <20110504115324.GE17855@lsi.com>
	 <1305616571.6008.23.camel@mulgrave.site>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	 <20110518041551.GL15227@parisc-linux.org>
	 <1305692584.2580.3.camel@mulgrave.site>	<1305702010.2781.33.camel@pasglop>
	<mpt2sas-writeq-powerpc64@mdm.bga.com>
	<4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
 <x86-32-writeq-is-broken@mdm.bga.com>
In-Reply-To: <x86-32-writeq-is-broken@mdm.bga.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011 12:31 PM Milton Miller wrote:
> Ingo I would propose the following commits added in 2.6.29 be reverted.
> I think the current concensus is drivers must know if the writeq is
> not atomic so they can provide their own locking or other workaround.
> 


Exactly.
