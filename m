Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0INH5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:57:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43014 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0INH5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cxcPEqveTM4kX7zgEzhkxqXUZHQkn+tOW3cb7FODbmM6Jun/ehw4n9XdmCcLUNXhEL
         j6UNGQUyyAOuy7k7/IOqGvQ/pQEUPpACXru5AHlmV0Q1ceZnhRBn1h+jTojHO3v1WfJl
         MpPl1MTTS90jRbAKD3+if7h22qhGhhLi8KCvE=
Date: Tue, 14 Sep 2010 00:57:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lech Perczak <lech.perczak@multivision.pl>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] hid: Fix for A4Tech RP-649 horizontal scrollwheel
Message-ID: <20100914075711.GC15167@core.coreip.homeip.net>
References: <4C891E9F.3040006@multivision.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C891E9F.3040006@multivision.pl>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 07:51:27PM +0200, Lech Perczak wrote:
>  From: Lech Perczak <lech.perczak@multivision.pl>
> 
> - Barely add USB device ID of A4Tech RF mouse receiver (09da:001a)

I think you were looking for word "simply".

> used with RP-649(Z) mice to enable fix for their horizontal scroll
> wheel behaviour, and associate it with B8 hack.
> 
-- 
Dmitry
