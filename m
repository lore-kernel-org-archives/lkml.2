Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2JHXyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:54:25 -0400
Received: from ozlabs.org ([203.10.76.45]:39302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2JHXyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:54:23 -0400
Message-ID: <1349740469.32656.2.camel@concordia>
Subject: Re: [PATCH 0/5] Move some OF functionality from pseries to generic
 OF code
From: Michael Ellerman <michael@ellerman.id.au>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 09 Oct 2012 10:54:29 +1100
In-Reply-To: <506B2E63.5090900@linux.vnet.ibm.com>
References: <506B2E63.5090900@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 13:11 -0500, Nathan Fontenot wrote:
> This set of patches moves some OF code that has been living
> in the pseries tree over to the generic OF code base. The
> functionality being migrated over is something that, I believe,
> should live in the generic code base. The specific functionality
> being migrated to generic OF code is;

Your changes collide with commit 475d0094293:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=475d0094293b51353e342d1198377967dbc48169


At a quick glance they don't look like they conflict in concept, just
textually.

cheers


