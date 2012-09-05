Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab2IEVt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:49:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41723 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606Ab2IEVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120905214142.GA29288@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-8-git-send-email-mjg@redhat.com>
	<1346879629.2054.22.camel@falcor.watson.ibm.com>
	<20120905214142.GA29288@srcf.ucam.org>
Date: Wed, 5 Sep 2012 17:49:53 -0400
Message-ID: <CACLa4pv_LcMieUSkB=RhFMqq3+oFytbrkQ56qg68zosJqMOaog@mail.gmail.com>
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
From: Eric Paris <eparis@parisplace.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 5:41 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Yeah, I think renaming the cap is a given.

CAP_RING_ZERO

Needed for any activity which would give root the ability to run code in ring 0?
