Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2F0WRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:17:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49570 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2F0WRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:17:49 -0400
Date: Wed, 27 Jun 2012 17:17:43 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Alex Hung <alex.hung@canonical.com>
Cc: Carsten Otto <otto@informatik.rwth-aachen.de>, corentincj@iksaif.net,
        mjg@redhat.com, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
Message-ID: <20120627221743.GC13738@burratino>
References: <1340164055-1062-1-git-send-email-alex.hung@canonical.com>
 <20120626213958.GA17871@burratino>
 <20120626215806.GM21479@carsten-otto>
 <4FEABBFC.6090708@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEABBFC.6090708@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Alex Hung wrote:

> Some Fn keys fail to work is probably the result of un-handled
> events, i.e. asus_wmi: Unknown key 7a pressed.
>
> Do you always receive the error messages for each of the Fn-keys
> that fails? I can take a closer look and try to fix each of them. I
> don't have a Asus Zenbook Prime but I can check on other available
> Asus machines.

It looks like your message didn't reach Carsten.  I'm cc-ing him now.

See http://bugs.debian.org/679158#62 for a summary of what each Fn-key
that fails does (it varies from key to key).

Regards,
Jonathan
