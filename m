Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0CSVqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:46:23 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:36989 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752466Ab0CSVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:46:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MjX3OvwXCxGJ6rAap3Ulk3mI5SiI+5kEBMSY4NWB19GR5YAlo7AnLBQAKS8utIChTHY9jV063v7r/YJYqxUVlRsy+AJxQyPhuLIkqt5ScIUPClMvbODxz4YnT2+YleB0;
Date: Fri, 19 Mar 2010 14:46:25 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, willy@linux.intel.com
Subject: Re: [PATCH] PCI: create function symlinks in /sys/bus/pci/slots/N/
Message-ID: <20100319144625.4247b7e6@jbarnes-piketon>
In-Reply-To: <20100308172429.GA20953@ldl.fc.hp.com>
References: <20100308172429.GA20953@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010 10:24:29 -0700
Alex Chiang <achiang@hp.com> wrote:

> Create convenience symlinks in sysfs, linking slots to device
> functions, and vice versa. These links make it easier for users to
> figure out which devices actually live in what slots.
> 
> For example:

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
