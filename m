Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2E1UkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:40:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59293 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2E1UkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:40:19 -0400
Date: Mon, 28 May 2012 15:40:12 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Victor Miasnikov <vvm@tut.by>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, KY Srinivasan <kys@microsoft.com>
Subject: Re: [ 00/91] 3.4.1-stable review Fw: [PATCH 1/2] libata: add a host
 flag to ignore detected ATA devices FW: use hv_storvsc instead of ata_piix
 to handle the IDE disks devices ( but not for the CD-ROM)
Message-ID: <20120528204012.GI14606@burratino>
References: <20120527010903.GA18244@kroah.com>
 <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
 <20120528203518.GA12623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528203518.GA12623@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> I do not understand, what exactly are the git commit ids that you wish
> to see applied to the stable tree?

I think he wants

  cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default

and its prerequisite

  db63a4c8115a libata: add a host flag to ignore detected ATA devices

Hope that helps,
Jonathan
