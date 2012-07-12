Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab2GLNpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:45:38 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:11347 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932480Ab2GLNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:45:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuoOAMvT/k9XQD44/2dsb2JhbABFjVOmS4IqBAOBKIEIgiABAQVWIgEQCxgJFg8JAwIBAgEnHgYNAQcBAYgNvWiLQIV8A5sQijCCYQ
Message-ID: <4FFED46F.1080600@computer.org>
Date: Thu, 12 Jul 2012 15:43:11 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1207111114460.1559-100000@iolanthe.rowland.org> <4FFECFC5.2080803@xs4all.nl>
In-Reply-To: <4FFECFC5.2080803@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 03:23 PM, Udo van den Heuvel wrote:
> How to list what modules/programs are using that irq?

cat /proc/interrupts
