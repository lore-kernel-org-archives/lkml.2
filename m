Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0JMMFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:05:18 -0400
Received: from lo.gmane.org ([80.91.229.12]:51262 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0JMMFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:05:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jurgen Braam <j.braam@homeautomationeurope.com>
Subject: Re: [PATCH][RFC] USB: EHCI: add missing {endpoint_reset,clear_tt_buffer_complete}
 operations
Date: Wed, 13 Oct 2010 14:01:41 +0200
Organization: Home Automation Europe
Message-ID: <4CB59FA5.2040803@homeautomationeurope.com>
References: <18494093.1383561286964261272.JavaMail.PC-43$@PC-43> <13257307.1383581286964359341.JavaMail.PC-43$@PC-43>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-usb@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 188.201.252.82
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
In-Reply-To: <13257307.1383581286964359341.JavaMail.PC-43$@PC-43>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grrr, I wish I had checked the linux-usb list sooner, then I probably 
would have found:
* [PATCH] [RFC] USB: EHCI: mark several functions as maybe unused
* [PATCH 1/2] USB: ehci-mxc: hook up two missing callbacks

In my defense, at first I did not suspect the observed ftdi_sio read 
problem to lie within the ehci-mxc driver. I only traced it there in the 
final hours of my quest.

Anyways, the proposed changes still stand for ~(mxc) ...

grtz,
Jurgen

