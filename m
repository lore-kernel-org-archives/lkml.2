Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1CXNht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:37:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62919 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1CXNhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:37:47 -0400
Message-ID: <4D8B48D2.1050704@ru.mvista.com>
Date: Thu, 24 Mar 2011 16:36:18 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Libor Pechacek <lpechacek@suse.cz>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: remove dead code from usb_deregister_dev()
References: <20110324132426.GA27561@fm.suse.cz>
In-Reply-To: <20110324132426.GA27561@fm.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-03-2011 16:24, Libor Pechacek wrote:

> The `name' variable is unused in usb_deregister_dev() since commit d6e5bcf.

    Please also specify that commit's summary in parens for the human readers, 
as asked by Linus.

> Signed-off-by: Libor Pechacek<lpechacek@suse.cz>

WBR, Sergei
