Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1GVPXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:23:55 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:58586 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754729Ab1GVPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:23:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ppf7NsYFD9ZJFPPNNI2Ypg+e3LF+jYvn0twOlchH1UcQ1MLMwB+y7VBIAH52fGluw1G8Ohm7YvUa/NiS0k5dq2JgjviSxuiS7FB99l8HURDAAOWhIyZ7d13Y1sjgRK00;
Date: Fri, 22 Jul 2011 08:23:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Assign values to 'pci_obff_signal_type'
 enumeration constants
Message-ID: <20110722082348.5af8abb5@jbarnes-desktop>
In-Reply-To: <20110707210036.696.13836.stgit@amt.stowe>
References: <20110707210036.696.13836.stgit@amt.stowe>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jul 2011 15:00:36 -0600
Myron Stowe <myron.stowe@redhat.com> wrote:

> From: Myron Stowe <mstowe@redhat.com>
> 
> 'pci_obff_signal_type' is passed between drivers and the kernel API.
> This patch explicitly assigns values to the enumeration type's constants
> which aids in detecting any future changes or additions that would break
> the kernel's ABI.
> 
> No functional change.
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
