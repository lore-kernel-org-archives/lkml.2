Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab2HWRWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:22:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50524 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2HWRWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:22:09 -0400
MIME-Version: 1.0
In-Reply-To: <201208231814.21168.tweek@tweek.dk>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
Date: Thu, 23 Aug 2012 19:22:07 +0200
Message-ID: <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: Martin Nybo Andersen <tweek@tweek.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86-32
- is deprecated since Linux supports X32.
- will slow down adoption of X32 - there won't be X32 versions of many
software - if new ABI was added, old one should be removed
- wastes time of developers who can spend their time supporting X32
instead of x86-32 or support x86-64 only as 99% of users will be able
to run x86-64 software if x86-32 will be dropped
- wouldn't be dropped this year, but there should be plan when it will
be dropped e.g. when Windows 9 will be released

On 8/23/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> Why?
