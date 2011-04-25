Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1DYCcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:32:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020Ab1DYCcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Pr/bNTvJvBUpS/UQ+fsLEJRUjoyeCxpfiDMWS7jJfDIwBtj14fvSTIoC0TQtKktD3w
         EavnuklD+sWMHNuhPm/kpVBgdRS4OhlrZwQm33A8XKsDwYAhVYNHv/AbBhVqdsmuVFDZ
         0XIaRoYpUfnP+oh0kXCGvsn4bozdX1AEvyby4=
Message-ID: <4DB4DD26.3090406@gmail.com>
Date: Mon, 25 Apr 2011 10:32:06 +0800
From: yeyouqun <yeyouqun1981@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; zh-CN; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: question about wait_event
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,I have some doubt about "wait_event". One group processes, say 
A, they calls "wait_event (wq, 1)", and one single process B calls 
"wake_up_all", the question is:

     B only run once, so all the processes in A that hold the lock of 
"wq" after B process, which will sleep on the "wq" forever, is it true? 
If true, how to stop it from happening?
