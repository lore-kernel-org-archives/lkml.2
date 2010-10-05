Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0JEFLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:11:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56338 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0JEFLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:11:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 14:06:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Robin Holt <holt@sgi.com>,
        steiner@sgi.com
Subject: Re: [PATCH 2/9] v3 Add mutex for adding/removing memory blocks
Message-Id: <20101005140604.6bbd8ae0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CA62896.2060307@austin.ibm.com>
References: <4CA62700.7010809@austin.ibm.com>
	<4CA62896.2060307@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 13:29:42 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Add a new mutex for use in adding and removing of memory blocks.  This
> is needed to avoid any race conditions in which the same memory block could
> be added and removed at the same time.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
Reviewed-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

