Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1I3Cok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:44:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52660 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1I3Coi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110928154200.GA2477@ram-ThinkPad-T61>
References: <CAErSpo70k6UnhvvOMgQQxJ6BHZOwym=-jaPMvOukAaCr-B0+cQ@mail.gmail.com>
 <4E5EFFBD.4050201@logix.net.nz> <CAErSpo6bofeiAxeRo_RjXQSnwmcWrdymn0MK8H4_CwqwoeD1jg@mail.gmail.com>
 <4E634814.4050508@logix.net.nz> <20110909113409.GE2416@ram-ThinkPad-T61>
 <4E6C05B7.9000904@logix.net.nz> <20110913110646.GB2425@ram-ThinkPad-T61>
 <4E6F400A.6090909@logix.net.nz> <20110922074858.GG5085@ram-ThinkPad-T61>
 <4E7B04F8.3090500@logix.net.nz> <20110928154200.GA2477@ram-ThinkPad-T61>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Sep 2011 19:44:17 -0700
X-Google-Sender-Auth: ucEYbmWB7SRB_iX4Nv4gMZtUMK4
Message-ID: <CA+55aFxAHTWu=ZVoMdfGwJ4xNgGeyk2CWrD+kJVH-qb4N=vhwA@mail.gmail.com>
Subject: Re: [PATCH] Resource: wrong resource window calculation
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, weiyang@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        Michal Ludvig <mludvig@logix.net.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 8:42 AM, Ram Pai <linuxram@us.ibm.com> wrote:
>
>        Do you plan to take this patch for 3.1? It fixes a regression w.r.t 3.0
>        https://bugzilla.kernel.org/show_bug.cgi?id=42002 captures the bug report.

It looks fine, but that bugzilla thing is currently useless. Do you
have some other place with the symptoms, discussion etc?  I didn't
find the original report on lkml..

      Linus
