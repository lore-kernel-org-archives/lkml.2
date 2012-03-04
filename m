Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2CDAND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:13:03 -0500
Received: from home.keithp.com ([63.227.221.253]:54059 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2CDANB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:13:01 -0500
From: Keith Packard <keithp@keithp.com>
To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        matt.fleming@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, rui.zhang@intel.com, stable@vger.kernel.org,
        huang.ying.caritas@gmail.com, matt.fleming@intel.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32 oops
In-Reply-To: <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org> <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 03 Mar 2012 16:12:53 -0800
Message-ID: <86zkbxusu2.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Wed, 22 Feb 2012 17:16:49 -0800, tip-bot for Matt Fleming <matt.fleming@intel.com> wrote:

> x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32 oops

This seems no different from the old fix -- I get 'Loading ...' and then
a nice black screen on my MacBook Air.

-- 
keith.packard@intel.com
