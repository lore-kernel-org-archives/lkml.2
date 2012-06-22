Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117Ab2FVDbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:31:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58810 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085Ab2FVDbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120529092154.GA2441@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com> <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
 <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
 <20120528140448.GA22783@redhat.com> <CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
 <20120529092154.GA2441@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 21 Jun 2012 21:30:49 -0600
Message-ID: <CAErSpo6Xxq_kcEYACKUsuNDOJDhEDnxWgBUateOJEBcfqufhSg@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kamil Grzebien <ciptok@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 3:21 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, May 28, 2012 at 12:21:34PM -0600, Bjorn Helgaas wrote:
>> linked in vs. loaded as a module after boot?  What if you add a long
>> delay in the driver probe routine?
>
> I'm attaching patch which add 200 ms delay after pci_enable_device() in
> ->probe routine.
>
> Stanislaw

Kamil, any news on this issue?
