Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1LCJQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 04:16:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51873 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1LCJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 04:16:36 -0500
Message-ID: <1322903774.3782.1.camel@lappy>
Subject: Re: [PATCH 3/5 V4] Add ioctl for KVM_GUEST_STOPPED
From: Sasha Levin <levinsasha928@gmail.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 03 Dec 2011 11:16:14 +0200
In-Reply-To: <1322602539-27004-4-git-send-email-emunson@mgebm.net>
References: <1322602539-27004-1-git-send-email-emunson@mgebm.net>
	 <1322602539-27004-4-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 16:35 -0500, Eric B Munson wrote:
> 
> Now that we have a flag that will tell the guest it was suspended,
> create an interface for that communication using a KVM ioctl.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net> 

Can it be documented in api.txt as well?

-- 

Sasha.

