Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0CQXo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:44:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab0CQXoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:44:25 -0400
Date: Wed, 17 Mar 2010 16:44:14 -0700
From: Greg KH <gregkh@suse.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dtor@mail.ru>, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [RFC/PATCH] platform_bus: allow custom extensions to system PM
 methods
Message-ID: <20100317234414.GA23319@suse.de>
References: <1268867896-7616-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268867896-7616-1-git-send-email-khilman@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 04:18:15PM -0700, Kevin Hilman wrote:
> When runtime PM for platform_bus was added, it allowed for platforms
> to customize the runtime PM methods since they are defined as weak
> symbols.
> 
> This patch allows platforms to also extend the system PM methods with
> custom hooks so runtime PM and system PM extensions can be managed
> together by custom platform-specific code.

Wow, that's scary, I didn't realize that was done for the runtime stuff.

What would you be replacing these functions with for your platform that
would require it to be in arch-specific code?

thanks,

greg k-h
