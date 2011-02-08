Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1BHRou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:44:50 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:23750 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754705Ab1BHRot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:44:49 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FyVjHDkVM1lDpV9PXzVu.jzW8ThXEV39MhcGev5bzxiQQuV
 fL7isLTSiYqJx02_twUtfkJPte3gq8cjtMmhoNxp5dPbmL698X12uA2KAWuy
 FNxj1GnDzvs9bVPHWwJVnufxgnHfS7F_UrZLkx1f7_7OLo60Ot6yJMx69tbF
 t01_N3a8hJPkCcXkI_RK3PAWi4mHk.B9tdjH9hWnm1rR4AW1dODJFOeagI7f
 AUec.QKMrdr6Q_bmmb.9tceE4AQ9GQTznlpchHRude1JQOpzpjWiQD9UKAYP
 u9Szk1AEY9nTnGbFeaZvZ26Z.ndz5yaTMIW2RKG01bfcgueQ-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 8 Feb 2011 11:44:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sedat Dilek <sedat.dilek@googlemail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        sandeen@redhat.com
Subject: Re: linux-next: build failure after merge of the slab tree
In-Reply-To: <AANLkTi=Hykzpb+oK7HOXJCCNwpgRRbsJNuXz-2Uc9WbB@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102081144170.15931@router.home>
References: <20110131144246.dfa2abe3.sfr@canb.auug.org.au> <1296502339.30654.13.camel@jaguar> <alpine.DEB.2.00.1102030919380.6519@router.home> <alpine.DEB.2.00.1102080952490.13202@router.home> <alpine.DEB.2.00.1102080954330.13649@router.home>
 <AANLkTi=Hykzpb+oK7HOXJCCNwpgRRbsJNuXz-2Uc9WbB@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Sedat Dilek wrote:

> Isn't the fs/ext4 part obsolete by Eric's "ext4: make grpinfo slab
> cache names static"?
> The mentionned patch is pending in ext4.git#{master, for_linus} [1].
>
> Shouldn't this patch reduced to the mm/slab part?

If Eric fixed it with string constants then we do not need the slab part
either.
