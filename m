Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1CALhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:37:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab1CALhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:37:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: james_p_freyensee@linux.intel.com
Subject: Re: [PATCH 04/10] PTI Makefile and Kconfig additions.
Date: Tue, 1 Mar 2011 12:37:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
References: <james_p_freyensee@linux.intel.com> <201102281031.42402.arnd@arndb.de> <1298915373.3156.34.camel@localhost>
In-Reply-To: <1298915373.3156.34.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011237.50400.arnd@arndb.de>
X-Provags-ID: V02:K0:BOqaToE9FnZTittQqKZmvgabsiS0C6nIx9FE+AveXu3
 7M3bWgl0SK5yIX4Q3CskKeyJ9V/M3gtDE0HyrrRfjpsi86Nq/Y
 rLDiFAyJRk9i/MkoRdQ/DFV5GnVVEvFnS01Z0aj+4ho5jMuX7W
 /X7L7PhejnTKc1Jo8KmHImnTD+lepXLq0y2qxyuAWkbisZv5hT
 vHnnqdVtJ5eQuI+zNBCNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 February 2011, J Freyensee wrote:
> On Mon, 2011-02-28 at 10:31 +0100, Arnd Bergmann wrote:
>
> > The Kconfig description is a nice text, how about copying it to the
> > changeset so that reviewers know what the driver is about?
> > 
> 
> I thought patch 02/10, 'Kernel documentation', would had been first and
> met this need?  

Documentation in source files is not the same as documentation in the
changelog, you need both. The changeset comments are usually just one
sentence in your series, and a little more would certainly be helpful.

Also, if you have one changeset with the documentation, that does
not help anyone who looks at another changeset.

	Arnd
