Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2HNApM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 20:45:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55052 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2HNApL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 20:45:11 -0400
Date: Mon, 13 Aug 2012 19:44:57 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH V2 1/2] gmux: Add generic write32 function
Message-ID: <20120814004457.GA18992@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <1344898369-4944-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344898369-4944-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 06:52:48PM -0400, Matthew Garrett wrote:
> Move the special-cased backlight update function to a generic gmux_write32
> function.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Seth Forshee <seth.forshee@canonical.com>

