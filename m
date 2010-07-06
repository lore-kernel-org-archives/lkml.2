Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0GFU71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 16:59:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50684 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab0GFU7Z (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 6 Jul 2010 16:59:25 -0400
Date: Tue, 6 Jul 2010 16:58:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com
Subject: Re: [PATCH V3 0/8] Cleancache: overview
Message-ID: <20100706205820.GB32627@phenom.dumpdata.com>
References: <20100621231809.GA11111@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621231809.GA11111@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C339914.0114:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:18:09PM -0700, Dan Magenheimer wrote:
> [PATCH V3 0/8] Cleancache: overview

Dan,

Two comments:
 - Mention where one can get the implementor of the cleancache API.
   Either a link to where the patches reside or a git branch.
   If you need pointers on branch names:
   http://lkml.org/lkml/2010/6/7/269

-  Point out the presentation you did on this. It has an excellent
   overview of how this API works, and most importantly: a) images
   and b). performance numbers.

Otherwise, please consider all of these patches to have
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

tag.
