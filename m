Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab2EPMV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:21:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61762 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2EPMV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:21:57 -0400
Date: Wed, 16 May 2012 05:21:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: mjg@redhat.com, tianyu.lan@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix breakage on systems without ACPI
Message-ID: <20120516122153.GA31684@kroah.com>
References: <1337170275-23859-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337170275-23859-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 02:11:15PM +0200, Sasha Levin wrote:
> Commit da0af6e ("usb: Bind devices to ACPI devices when possible") really
> tries to force-bind devices even when impossible, unlike what it says in
> the subject.
> 
> CONFIG_ACPI is not an indication that ACPI tables are actually present, nor
> is an indication that any USB relevant information is present in them. There
> is no reason to fail the creation of a USB bus if it can't bind it to
> ACPI device during initialization.
> 
> On systems with CONFIG_ACPI set but without ACPI tables it would cause a
> boot panic.

Nice catch, sorry about that, I'll go queue this up.

greg k-h
