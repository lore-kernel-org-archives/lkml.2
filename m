Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab2JBKyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:54:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44180 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab2JBKyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:54:45 -0400
Date: Tue, 2 Oct 2012 11:54:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: Duplicate sysfs file: microamps_requested_vmmc
Message-ID: <20121002105442.GW4360@opensource.wolfsonmicro.com>
References: <CAErSpo7SxK8F_M0kfRRr0k23UVNCtZXpMkcsGY3mJ_qsx3KBkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7SxK8F_M0kfRRr0k23UVNCtZXpMkcsGY3mJ_qsx3KBkw@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:22:19PM -0600, Bjorn Helgaas wrote:
> This is an old bug report I'd like to close out.  Do you guys know
> anything about it?  I couldn't even find the
> "microamps_requested_vmmc" string in the v3.6 kernel, so I suspect
> it's obsolete.

You can't find the string because it's constructed at runtime with
sprintf().  It's probably a bug in whatever driver is requesting the
supply twice.
