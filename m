Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2LDLe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:34:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52528 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDLe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:34:58 -0500
Date: Tue, 04 Dec 2012 05:34:54 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Why a host not ping-able?
To: Woody Wu <narkewoody@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <slrnkbr59r.us1.narkewoody@zuhnb712.local.com> (from
	narkewoody@gmail.com on Tue Dec  4 00:17:25 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1354620894.27682.5@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 12:17:25 AM, Woody Wu wrote:
> Hi, list
> 
> I am not sure this has something with kernel.

It doesn't.

> But the system I just
> generated cannot be reached from ping.  It can ping outside, but if I
> ping it from outside, I just get "Destination Host Unreachable".

Some distributions' default firewall rules respond to icmp packets with  
a host unreachable packet. This is a system/network administration  
thing (iptables) and nothing to do with kernel development.

> I think there is not firewall in between,

There's a firewall  built into linux, read the man page for the  
"iptables" command. The "iptables-save" command dumps your entire  
current ruleset to stdout so you can see what's in there. (You might  
have to run it as root, I forget.)

https://help.ubuntu.com/community/IptablesHowTo

Rob