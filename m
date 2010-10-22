Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0JVN4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:56:12 -0400
Received: from kroah.org ([198.145.64.141]:47314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab0JVN4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:56:10 -0400
Date: Fri, 22 Oct 2010 06:56:50 -0700
From: Greg KH <greg@kroah.com>
To: "Emilio G. Cota" <cota@braap.org>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [-next] staging/vme: various fixes + new driver model for VME
Message-ID: <20101022135650.GB2386@kroah.com>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:36:22AM -0400, Emilio G. Cota wrote:
> Hi Greg,
> 
> This contains first a whole bunch of fixes to the existing vme
> code in staging, to then introduce a new driver model for VME
> in patch 27.

You did see my message yesterday that stated "the merge window is closed
for .37 patches for staging", right?

Also, these need to get Martyn's ack before I can accept them.  Please
work with him to get the different things resolved.

thanks,

greg k-h
