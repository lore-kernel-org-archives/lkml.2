Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0FNUsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:48:13 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:54706 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755323Ab0FNUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:48:11 -0400
Date: Mon, 14 Jun 2010 16:48:05 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
Message-ID: <20100614204805.GA12589@elliptictech.com>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-2-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276547208-26569-2-git-send-email-justinmattock@gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:26 Mon 14 Jun     , Justin P. Mattock wrote:
> @@ -617,8 +616,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>  
>  	pathrelse(search_path);
>  
> -	right_neighbor_of_leaf_node = 0;
> -
> +	

This hunk introduces whitespace on the empty line, which is not cool.

>  	/* With each iteration of this loop we search through the items in the
>  	   current node, and calculate the next current node(next path element)
>  	   for the next iteration of this loop.. */
> @@ -695,8 +693,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>  			   starting from the root. */
>  			block_number = SB_ROOT_BLOCK(sb);
>  			expected_level = -1;
> -			right_neighbor_of_leaf_node = 0;
> -
> +			

Here, too.

Most of the patches in this series have similar issues.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
