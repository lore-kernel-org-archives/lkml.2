Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2HNAqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 20:46:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2HNAqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 20:46:37 -0400
Date: Mon, 13 Aug 2012 19:46:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: Re: [PATCH V2 2/2] apple_gmux: Add support for newer hardware
Message-ID: <20120814004625.GB18992@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	Bernhard Froemel <froemel@vmars.tuwien.ac.at>
References: <1344898369-4944-1-git-send-email-mjg@redhat.com>
 <1344898369-4944-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344898369-4944-2-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 06:52:49PM -0400, Matthew Garrett wrote:
> New gmux devices have a different method for accessing the registers.
> Update the driver to cope. Incorporates feedback from Bernhard Froemel.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
> Cc: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Seth Forshee <seth.forshee@canonical.com>

