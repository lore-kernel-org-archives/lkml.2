Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab2COSJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:09:17 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12971 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2COSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:09:12 -0400
Message-ID: <4F623046.30500@hp.com>
Date: Thu, 15 Mar 2012 11:09:10 -0700
From: Don Morris <don.morris@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Liz Clark <liz.clark@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
References: <1331832809-4484-1-git-send-email-liz.clark@hp.com> <20120315180312.GC26442@kroah.com>
In-Reply-To: <20120315180312.GC26442@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 11:03 AM, Greg KH wrote:
> On Thu, Mar 15, 2012 at 10:33:29AM -0700, Liz Clark wrote:
>> Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map
> 
> What bugzilla are you referring to here?  bugs.gentoo.org?  :)
> 

https://bugzilla.kernel.org/show_bug.cgi?id=40012

Don Morris

