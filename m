Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1CXC6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:58:51 -0400
Received: from ozlabs.org ([203.10.76.45]:38109 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab1CXC6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:58:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, adobriyan@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC PATCH 0/3] Introduce kstrtobool function
In-Reply-To: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 24 Mar 2011 11:04:53 +1030
Message-ID: <87oc51bbki.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 13:39:11 +0000, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> Dear all,
> 
> This is an initial stab at a simple utility function intended to pin
> down what the kernel considers to be 'true' and 'false'.  My original
> query was centered around processing of sysfs inputs but as Greg
> pointed out there are a couple of other places in kernel where this
> functionality would be useful.

Seems reasonable.

Rusty.
