Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1B1JaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:30:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1B1JaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:30:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: james_p_freyensee@linux.intel.com
Subject: Re: [PATCH 05/10] PTI header file.
Date: Mon, 28 Feb 2011 10:30:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
References: <james_p_freyensee@linux.intel.com> <1298570824-26085-6-git-send-email-james_p_freyensee@linux.intel.com>
In-Reply-To: <1298570824-26085-6-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281030.15719.arnd@arndb.de>
X-Provags-ID: V02:K0:68mIxMHnVZ7oHMDcHhqTrdoAXJOwUnNKY65y790E2jV
 YmPoLq7UkXkKg/J5g+3maNMEzZ0g/Jhih1LSY7Dj1qD9RXvfFA
 Z9lVpwpu98/+PUckIph68sbVFsmgS021paTtBiDhsdkRcl5pQW
 IDUDnaCFH9q1x0XX3hlPK1vDuMbRLxocBPWH7pz6I1DuuFeBgV
 4MBsYuY3pcZZ40PGtsRDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 February 2011, james_p_freyensee@linux.intel.com wrote:
> 
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This adds PTI header information for the PTI project.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

Don't split the changes by file, but by functionality.

The header file belongs with the code whose interfaces it exports, so
merge it into that patch.

Just make sure that the patch order is right, so you introduce the file before
you use it.

	Arnd
