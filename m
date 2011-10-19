Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1JSHTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:19:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35146 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab1JSHTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <1319004938.31823.59.camel@wwguy-huron>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	<alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	<CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com>
	<1319003710.31823.53.camel@wwguy-huron>
	<20111019064818.GB14817@gamma.logic.tuwien.ac.at>
	<1319004938.31823.59.camel@wwguy-huron>
Date: Wed, 19 Oct 2011 10:19:03 +0300
X-Google-Sender-Auth: nP272YWHcvv2xxP-mt2m-BZmtpw
Message-ID: <CAOJsxLHLmtYAR1c34Kkn+hzGeOSwhU646PP04pvTFx2e5M0NfA@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Norbert Preining <preining@logic.at>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wey,

On Wed, Oct 19, 2011 at 9:15 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Sorry, I was thinking ask Pekka to use the officialfirmware. But more
> important, I will like to find out is Pekka has the same issue as you
> have which is tx queue stopped.

I'm happy to help but I have no idea what you want me to do :-). When
my internet connection dies the next time, what do you want me to
capture for you? What's official firmware? I'm using Fedora 15 with
3.1-rc9 built from sources here. Do you want to see my lspci, .config,
dmesg, something else?

As for the problems, I'm using iPhone 3G internet via WiFi sharing and
connection seems to die few times a day or if I take the phone far
enough from the laptop. I usually turn off the AP for a while and use
NetworkManager on the laptop to disable/enable networking to make it
come back up.

I haven't tested anything but 3.1-rcX kernels on this machine but I
can do git bisect too if it comes to that.

                        Pekka
