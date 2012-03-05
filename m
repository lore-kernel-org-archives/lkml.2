Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2CEWG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:06:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38795 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2CEWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:06:58 -0500
Date: Mon, 5 Mar 2012 16:06:51 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120305220651.GB16312@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 08:37:37AM -0600, Seth Forshee wrote:
> Apple laptops with hybrid graphics have a device named gmux that
> controls the muxing of the LVDS panel between the GPUs as well as screen
> brightness. This driver adds support for the gmux device. Only backlight
> control is supported initially.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Ping. Is there anything that would prevent getting this into 3.4?

Seth

