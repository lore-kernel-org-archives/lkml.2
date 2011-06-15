Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1FOXiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 19:38:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:55448 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1FOXiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 19:38:10 -0400
Date: Thu, 16 Jun 2011 09:38:04 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: Re: [RFC v1 1/5] crypto: GnuPG based MPI lib
In-Reply-To: <de6d48b4ace4f23545aa220f4a06bb189ae703e9.1307522457.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.LRH.2.00.1106160936590.8929@tundra.namei.org>
References: <cover.1307522457.git.dmitry.kasatkin@intel.com> <de6d48b4ace4f23545aa220f4a06bb189ae703e9.1307522457.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Dmitry Kasatkin wrote:

> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> 
> Adds the multi-precision-integer maths library which was originally taken
> from GnuPG and ported to the kernel by (among others) David Howells.
> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.

FYI, any future postings should be cc'd to the linux-crypto list.

-- 
James Morris
<jmorris@namei.org>
