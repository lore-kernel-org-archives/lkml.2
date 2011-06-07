Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1FGSfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:35:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2599 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab1FGSfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:35:43 -0400
Subject: RE: [PATCH] treewide: Convert uses of struct resource * to
 resource_size(ptr)
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
	 <1307408678.4994.46.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 11:35:41 -0700
Message-ID: <1307471741.22272.24.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 13:27 -0500, H Hartley Sweeten wrote:
> On Monday, June 06, 2011 6:05 PM, Joe Perches wrote:
> > There are quite a few left...
> FWIW, your patch missed a couple...

Yup.

There are also several uses of struct resource var;
var.end - var.start with or without +1.

I'm going through them now and will resubmit.


