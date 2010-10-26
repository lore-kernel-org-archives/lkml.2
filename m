Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0JZA7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:59:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0JZA7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b3W1gnMqp2/1I2lTK6HeQSVPXRs2uCuXFDor5Y0/jbixwzT0SMnH5BqAKi205xC4DW
         lBgwVf+iS1WSikvUdGvz7L3KhFpricSVllEy/Db9cWdxqz6Df7cZeML4eT5tloKDOTMn
         QFP9RnKwNaj/RrKaa13mC8SANnFIsF7xGLpL8=
MIME-Version: 1.0
In-Reply-To: <1288054306-4361-9-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<1288054306-4361-2-git-send-email-x0095840@ti.com>
	<1288054306-4361-3-git-send-email-x0095840@ti.com>
	<1288054306-4361-4-git-send-email-x0095840@ti.com>
	<1288054306-4361-5-git-send-email-x0095840@ti.com>
	<1288054306-4361-6-git-send-email-x0095840@ti.com>
	<1288054306-4361-7-git-send-email-x0095840@ti.com>
	<1288054306-4361-8-git-send-email-x0095840@ti.com>
	<1288054306-4361-9-git-send-email-x0095840@ti.com>
Date: Tue, 26 Oct 2010 03:58:59 +0300
Message-ID: <AANLkTinnLb9DLMKfxEs_KqMvOmegSDYRuLWh5y=hhBCe@mail.gmail.com>
Subject: Re: [PATCH 8/8] staging: tidspbridge - make sync_wait_on_event interruptible
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: gregkh@suse.de, felipe.contreras@nokia.com, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> So that avoid non-killable process.

It would be useful to interrupt these tasks from user-space. A
separate ioctl to do that would be needed.

-- 
Felipe Contreras
