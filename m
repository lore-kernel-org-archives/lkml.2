Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2HMUzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:55:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2HMUzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:55:21 -0400
Date: Mon, 13 Aug 2012 15:55:09 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 1/2] gmux: Add generic write32 function
Message-ID: <20120813205509.GI24088@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <1344889232-3907-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344889232-3907-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:20:31PM -0400, Matthew Garrett wrote:
> +	gmux_write32(gmux_data, GMUX_PORT_BRIGHTNES, brightness);

Also, typo here. Should be GMUX_PORT_BRIGHTNESS.

