Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0DWEqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 00:46:44 -0400
Received: from kroah.org ([198.145.64.141]:60914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab0DWEqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 00:46:42 -0400
Date: Thu, 22 Apr 2010 21:39:40 -0700
From: Greg KH <greg@kroah.com>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 0/9] Suspend block api (version 4)
Message-ID: <20100423043940.GB4198@kroah.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271984938-13920-1-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 06:08:49PM -0700, Arve Hj??nnev??g wrote:
> This patch series adds a suspend-block api that provides the same
> functionality as the android wakelock api. The code is mostly the
> same as version 3 posted last year, but the main entry point has
> changed back to /sys/power/state with a new /sys/power/policy to
> alter its behavior. Timeout support is not included in this initial
> patchset.

Yeah!  Thanks for respining this and pushing it out.  This should help
lots of drivers get merged after this is in-tree.

thanks again,

greg k-h
