Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab3AHFwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:52:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54107 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911Ab3AHFwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:52:22 -0500
Message-ID: <1357624342.12749.47.camel@joe-AO722>
Subject: Re: [TRIVIAL PATCH 00/26] treewide: Add and use vsprintf extension
 %pSR
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2013 21:52:22 -0800
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 10:18 -0800, Joe Perches wrote:
> Remove the somewhat awkward uses of print_symbol and convert all the
> existing uses to a new vsprintf pointer type of %pSR.

Jiri?  Are you going to do anything with this?

