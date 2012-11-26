Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2KZUId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:08:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab2KZUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:08:32 -0500
Date: Mon, 26 Nov 2012 18:08:20 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jacob Shin <jacob.shin@amd.com>
Subject: Re: [PATCH 168/270] x86: Exclude E820_RESERVED regions and memory
 holes above 4 GB from direct mapping.
Message-ID: <20121126200819.GD3331@herton-Z68MA-D2H-B3>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-169-git-send-email-herton.krzesinski@canonical.com>
 <50B3AEA1.9010802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B3AEA1.9010802@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 10:02:09AM -0800, H. Peter Anvin wrote:
> On 11/26/2012 08:57 AM, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> 
> What kind of version number is that?

This is an "extended stable" tree, a fork from the last 3.5 stable
update (3.5 isn't maintained anymore by stable upstream). Thus
it seemed better to just follow last released 3.5 stable version, and
append an extraversion to it, which I chose in the end to be u<n>
(u == update). It's unlikely that other 3.5 stable upstream update will
be done, in any case I expect this way to avoid any issue.

> 
> 	-hpa
> 
> 

-- 
[]'s
Herton
