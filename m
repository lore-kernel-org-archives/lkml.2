Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1HLBU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:20:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58082 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1HLBUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:20:25 -0400
Date: Fri, 12 Aug 2011 02:20:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tonda <as@strmilov.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Module hiding files controlled by sysfs
Message-ID: <20110812012023.GS2203@ZenIV.linux.org.uk>
References: <1313106903-18702-1-git-send-email-as@strmilov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313106903-18702-1-git-send-email-as@strmilov.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 01:55:03AM +0200, Tonda wrote:

NAK.  For many, _many_ reasons.  We don't merge rootkits, to start with.
Even ones that happen to be x86-only.
