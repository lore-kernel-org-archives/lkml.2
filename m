Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab2C2W6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:58:41 -0400
Received: from fifo99.com ([67.223.236.141]:34850 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760270Ab2C2W6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:58:33 -0400
Date: Thu, 29 Mar 2012 15:58:33 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329225833.GB18865@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
 <20120329145055.GE13912@fifo99.com>
 <4F748CF6.4010205@am.sony.com>
 <20120329175209.GE16476@fifo99.com>
 <20120329195007.07d53db7@pyramind.ukuu.org.uk>
 <4F74DFDC.6060904@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F74DFDC.6060904@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 03:19:08PM -0700, Tim Bird wrote:
> environment.  But if it can be made harder for a bad program to
> cover it's tracks, that would be nice.

Do you think adding this extra level of security is worth adding a new
kernel interface for logging ?

Daniel
