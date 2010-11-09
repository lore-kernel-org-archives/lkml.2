Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0KIFnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:43:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48772 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0KIFm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:42:59 -0500
MIME-Version: 1.0
In-Reply-To: <1289179439.3090.205.camel@Dan>
References: <1289179439.3090.205.camel@Dan>
Date: Tue, 9 Nov 2010 13:42:58 +0800
Message-ID: <AANLkTikuhR0=m7rhdhLhSR8pvL0cHfdB14-RqKPtWywt@mail.gmail.com>
Subject: Re: [Security] [PATCH RFC] Restrictions on module loading
From: Eugene Teo <eugeneteo@kernel.sg>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 9:23 AM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
[...]
> The below patch replaces the existing "modules_disable" sysctl with a
> finer-grained "modules_restrict" sysctl.  By default, this is set at 0,

I suggest that we either keep the existing "modules_disable" sysctl
variable and build on top of it, or use another sysctl variable.

Thanks, Eugene
