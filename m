Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2EUSBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:01:46 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:44197 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab2EUSBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:01:37 -0400
Date: Mon, 21 May 2012 20:01:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, relocs: build clean fix
Message-ID: <20120521180134.GA5890@merkur.ravnborg.org>
References: <1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 08:51:24PM +0300, Jarkko Sakkinen wrote:
> relocs was not cleaned up when "make clean" is issued. This
> patch fixes the issue.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Stable candidate?

	Sam
