Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0GLPGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:06:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab0GLPGu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 12 Jul 2010 11:06:50 -0400
Date: Mon, 12 Jul 2010 11:05:22 -0400
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
Subject: Re: [PATCH] Cleancache: shim to Xen Transcendent Memory
Message-ID: <20100712150522.GD5358@phenom.dumpdata.com>
References: <20100708164208.GA11763@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708164208.GA11763@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C3B2F70.0193:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 09:42:08AM -0700, Dan Magenheimer wrote:
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

One nitpick:
..
> +
> +int tmem_enabled;
> +
> +static int __init enable_tmem(char *s)
> +{
> +	tmem_enabled = 1;
> +	return 1;
> +}
> +
> +__setup("tmem", enable_tmem);

Perhaps 'tmem_setup' is more appropiate as it might be that this
function in the future would be only used to disable tmem, not actually
enable it?

Otherwise, it has been reviewed by me.
