Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0DWEiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 00:38:17 -0400
Received: from kroah.org ([198.145.64.141]:55229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0DWEiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 00:38:14 -0400
Date: Thu, 22 Apr 2010 21:38:14 -0700
From: Greg KH <greg@kroah.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
	suspend blockers from user-space
Message-ID: <20100423043814.GA4198@kroah.com>
References: <1271984938-13920-1-git-send-email-arve@android.com> <1271984938-13920-2-git-send-email-arve@android.com> <1271984938-13920-3-git-send-email-arve@android.com> <20100423022522.GB32490@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423022522.GB32490@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 07:25:22PM -0700, Matt Helsley wrote:
> Should the kernel reject empty strings or strings composed only of
> "non-printing" characters?

The kernel doesn't care, if you want to use non-printing characters, who
is it to complain?  :)

thanks,

greg k-h
