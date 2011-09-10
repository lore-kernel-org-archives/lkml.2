Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab1IJUau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 16:30:50 -0400
Received: from mail.infrascan.de ([188.40.84.136]:34193 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1IJUas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 16:30:48 -0400
Message-ID: <4E6BC8F5.80102@sensortherm.de>
Date: Sat, 10 Sep 2011 22:30:45 +0200
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: gregkh@suse.de
CC: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: clean up FSF boilerplate text
References: <1315686255-12892-1-git-send-email-schwarzkopf@sensortherm.de>
In-Reply-To: <1315686255-12892-1-git-send-email-schwarzkopf@sensortherm.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry there is no "[PATCH 1/2]", my mistake.

Can i delete the two paragraphs in the other subsystems?

Regards,

Klaus


Am 10.09.2011 22:24, schrieb Klaus Schwarzkopf:
>      remove the following two paragraphs:
>
>      This program is distributed in the hope that it will be useful, but
>      WITHOUT ANY WARRANTY; without even the implied warranty of
>      MERCHANTABILITY or
>      FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>      License for more details.
>
>      You should have received a copy of the GNU General Public License along
>      with this program; if not, write to the Free Software Foundation, Inc.,59
>      Temple Place - Suite 330, Boston, MA  02111-1307, USA.
>
> Signed-off-by: Klaus Schwarzkopf<schwarzkopf@sensortherm.de>
> ---
>   drivers/usb/atm/cxacru.c                 |   10 ----------
>   drivers/usb/atm/speedtch.c               |   10 ----------
>   drivers/usb/atm/ueagle-atm.c             |   10 ----------
>   drivers/usb/atm/usbatm.c                 |   10 ----------
>   drivers/usb/atm/usbatm.h                 |   10 ----------
>   drivers/usb/atm/xusbatm.c                |   10 ----------
>   drivers/usb/c67x00/c67x00-drv.c          |   10 ----------
>   drivers/usb/c67x00/c67x00-hcd.c          |   10 ----------
>   drivers/usb/c67x00/c67x00-hcd.h          |   10 ----------
>   drivers/usb/c67x00/c67x00-ll-hpi.c       |   10 ----------
>   drivers/usb/c67x00/c67x00-sched.c        |   10 ----------
>   drivers/usb/c67x00/c67x00.h              |   10 ----------
>   drivers/usb/class/cdc-acm.c              |    9 ---------
>   drivers/usb/class/usblp.c                |    9 ---------
>   drivers/usb/core/devio.c                 |    9 ---------
>   drivers/usb/core/hcd-pci.c               |    9 ---------
>   drivers/usb/core/hcd.c                   |    9 ---------
>   drivers/usb/host/ehci-dbg.c              |    9 ---------
>   drivers/usb/host/ehci-fsl.h              |    9 ---------
>   drivers/usb/host/ehci-grlib.c            |    9 ---------
>   drivers/usb/host/ehci-hcd.c              |    9 ---------
>   drivers/usb/host/ehci-hub.c              |    9 ---------
>   drivers/usb/host/ehci-lpm.c              |    9 ---------
>   drivers/usb/host/ehci-mem.c              |    9 ---------
>   drivers/usb/host/ehci-mxc.c              |    9 ---------
>   drivers/usb/host/ehci-pci.c              |    9 ---------
>   drivers/usb/host/ehci-ps3.c              |    9 ---------
>   drivers/usb/host/ehci-q.c                |    9 ---------
>   drivers/usb/host/ehci-sched.c            |    9 ---------
>   drivers/usb/host/ehci-xilinx-of.c        |   10 ----------
>   drivers/usb/host/ehci.h                  |    9 ---------
>   drivers/usb/host/imx21-dbg.c             |    9 ---------
>   drivers/usb/host/imx21-hcd.c             |    9 ---------
>   drivers/usb/host/imx21-hcd.h             |    9 ---------
>   drivers/usb/host/ohci-jz4740.c           |    5 -----
>   drivers/usb/host/ohci-ps3.c              |    9 ---------
>   drivers/usb/host/ohci-sh.c               |   10 ----------
>   drivers/usb/host/oxu210hp-hcd.c          |    9 ---------
>   drivers/usb/host/r8a66597-hcd.c          |   10 ----------
>   drivers/usb/host/r8a66597.h              |   10 ----------
>   drivers/usb/host/whci/whcd.h             |   10 ----------
>   drivers/usb/host/whci/whci-hc.h          |   10 ----------
>   drivers/usb/host/xhci-dbg.c              |    9 ---------
>   drivers/usb/host/xhci-ext-caps.h         |    9 ---------
>   drivers/usb/host/xhci-hub.c              |    9 ---------
>   drivers/usb/host/xhci-mem.c              |    9 ---------
>   drivers/usb/host/xhci-pci.c              |    9 ---------
>   drivers/usb/host/xhci-ring.c             |    9 ---------
>   drivers/usb/host/xhci.c                  |    9 ---------
>   drivers/usb/host/xhci.h                  |    9 ---------
>   drivers/usb/image/mdc800.c               |    9 ---------
>   drivers/usb/misc/appledisplay.c          |    9 ---------
>   drivers/usb/misc/rio500_usb.h            |   10 ----------
>   drivers/usb/misc/trancevibrator.c        |    9 ---------
>   drivers/usb/musb/am35x.c                 |    6 ------
>   drivers/usb/musb/da8xx.c                 |    6 ------
>   drivers/usb/musb/davinci.c               |    6 ------
>   drivers/usb/musb/omap2430.c              |    6 ------
>   drivers/usb/musb/ux500.c                 |    9 ---------
>   drivers/usb/otg/ab8500-usb.c             |   10 ----------
>   drivers/usb/otg/fsl_otg.c                |    9 ---------
>   drivers/usb/otg/fsl_otg.h                |    9 ---------
>   drivers/usb/otg/isp1301_omap.c           |    9 ---------
>   drivers/usb/otg/langwell_otg.c           |   10 ----------
>   drivers/usb/otg/otg_fsm.c                |    9 ---------
>   drivers/usb/otg/otg_fsm.h                |    9 ---------
>   drivers/usb/otg/twl6030-usb.c            |   10 ----------
>   drivers/usb/otg/ulpi.c                   |    9 ---------
>   drivers/usb/renesas_usbhs/common.c       |   10 ----------
>   drivers/usb/renesas_usbhs/common.h       |   10 ----------
>   drivers/usb/renesas_usbhs/mod.c          |   10 ----------
>   drivers/usb/renesas_usbhs/mod.h          |   10 ----------
>   drivers/usb/renesas_usbhs/mod_gadget.c   |   10 ----------
>   drivers/usb/renesas_usbhs/pipe.c         |   10 ----------
>   drivers/usb/renesas_usbhs/pipe.h         |   10 ----------
>   drivers/usb/serial/garmin_gps.c          |    9 ---------
>   drivers/usb/storage/alauda.c             |    9 ---------
>   drivers/usb/storage/cypress_atacb.c      |    9 ---------
>   drivers/usb/storage/datafab.c            |    9 ---------
>   drivers/usb/storage/debug.c              |    9 ---------
>   drivers/usb/storage/debug.h              |    9 ---------
>   drivers/usb/storage/ene_ub6250.c         |    9 ---------
>   drivers/usb/storage/initializers.c       |    9 ---------
>   drivers/usb/storage/initializers.h       |    9 ---------
>   drivers/usb/storage/jumpshot.c           |    9 ---------
>   drivers/usb/storage/karma.c              |    9 ---------
>   drivers/usb/storage/onetouch.c           |   10 ----------
>   drivers/usb/storage/option_ms.c          |    9 ---------
>   drivers/usb/storage/protocol.c           |    9 ---------
>   drivers/usb/storage/protocol.h           |    9 ---------
>   drivers/usb/storage/scsiglue.c           |    9 ---------
>   drivers/usb/storage/scsiglue.h           |    9 ---------
>   drivers/usb/storage/sddr09.c             |    9 ---------
>   drivers/usb/storage/sddr55.c             |    9 ---------
>   drivers/usb/storage/shuttle_usbat.c      |    9 ---------
>   drivers/usb/storage/transport.c          |    9 ---------
>   drivers/usb/storage/transport.h          |    9 ---------
>   drivers/usb/storage/unusual_alauda.h     |    9 ---------
>   drivers/usb/storage/unusual_cypress.h    |    9 ---------
>   drivers/usb/storage/unusual_datafab.h    |    9 ---------
>   drivers/usb/storage/unusual_devs.h       |    9 ---------
>   drivers/usb/storage/unusual_ene_ub6250.h |    9 ---------
>   drivers/usb/storage/unusual_freecom.h    |    9 ---------
>   drivers/usb/storage/unusual_isd200.h     |    9 ---------
>   drivers/usb/storage/unusual_jumpshot.h   |    9 ---------
>   drivers/usb/storage/unusual_karma.h      |    9 ---------
>   drivers/usb/storage/unusual_onetouch.h   |    9 ---------
>   drivers/usb/storage/unusual_sddr09.h     |    9 ---------
>   drivers/usb/storage/unusual_sddr55.h     |    9 ---------
>   drivers/usb/storage/unusual_usbat.h      |    9 ---------
>   drivers/usb/storage/usb.c                |    9 ---------
>   drivers/usb/storage/usb.h                |    9 ---------
>   drivers/usb/storage/usual-tables.c       |    9 ---------
>   113 files changed, 0 insertions(+), 1031 deletions(-)
>
> diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
> index a845f8b..548c85c 100644
> --- a/drivers/usb/atm/cxacru.c
> +++ b/drivers/usb/atm/cxacru.c
> @@ -11,16 +11,6 @@
>    *  under the terms of the GNU General Public License as published by the Free
>    *  Software Foundation; either version 2 of the License, or (at your option)
>    *  any later version.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
>    ******************************************************************************/
>
>   /*
> diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
> index 0842cfb..8b0c24c 100644
> --- a/drivers/usb/atm/speedtch.c
> +++ b/drivers/usb/atm/speedtch.c
> @@ -11,16 +11,6 @@
>    *  under the terms of the GNU General Public License as published by the Free
>    *  Software Foundation; either version 2 of the License, or (at your option)
>    *  any later version.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
>    ******************************************************************************/
>
>   #include<asm/page.h>
> diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
> index e71521c..d6727c5 100644
> --- a/drivers/usb/atm/ueagle-atm.c
> +++ b/drivers/usb/atm/ueagle-atm.c
> @@ -39,16 +39,6 @@
>    * as published by the Free Software Foundation; either version 2
>    * of the License, or (at your option) any later version.
>    *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - *
>    * HISTORY : some part of the code was base on ueagle 1.3 BSD driver,
>    * Damien Bergamini agree to put his code under a DUAL GPL/BSD license.
>    *
> diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
> index 989e16e..a35a215 100644
> --- a/drivers/usb/atm/usbatm.c
> +++ b/drivers/usb/atm/usbatm.c
> @@ -9,16 +9,6 @@
>    *  under the terms of the GNU General Public License as published by the Free
>    *  Software Foundation; either version 2 of the License, or (at your option)
>    *  any later version.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
>    ******************************************************************************/
>
>   /*
> diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
> index 5fc4894..63fadd8 100644
> --- a/drivers/usb/atm/usbatm.h
> +++ b/drivers/usb/atm/usbatm.h
> @@ -9,16 +9,6 @@
>    *  under the terms of the GNU General Public License as published by the Free
>    *  Software Foundation; either version 2 of the License, or (at your option)
>    *  any later version.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
>    ******************************************************************************/
>
>   #ifndef	_USBATM_H_
> diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
> index 48ee0c5..54279e3 100644
> --- a/drivers/usb/atm/xusbatm.c
> +++ b/drivers/usb/atm/xusbatm.c
> @@ -7,16 +7,6 @@
>    *  under the terms of the GNU General Public License as published by the Free
>    *  Software Foundation; either version 2 of the License, or (at your option)
>    *  any later version.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
>    ******************************************************************************/
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/c67x00/c67x00-drv.c b/drivers/usb/c67x00/c67x00-drv.c
> index 62050f7..71627cd 100644
> --- a/drivers/usb/c67x00/c67x00-drv.c
> +++ b/drivers/usb/c67x00/c67x00-drv.c
> @@ -9,16 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> - * MA  02110-1301  USA.
>    */
>
>   /*
> diff --git a/drivers/usb/c67x00/c67x00-hcd.c b/drivers/usb/c67x00/c67x00-hcd.c
> index d3e1356..c7e1147 100644
> --- a/drivers/usb/c67x00/c67x00-hcd.c
> +++ b/drivers/usb/c67x00/c67x00-hcd.c
> @@ -9,16 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> - * MA  02110-1301  USA.
>    */
>
>   #include<linux/device.h>
> diff --git a/drivers/usb/c67x00/c67x00-hcd.h b/drivers/usb/c67x00/c67x00-hcd.h
> index e3d493d..6ac62b6 100644
> --- a/drivers/usb/c67x00/c67x00-hcd.h
> +++ b/drivers/usb/c67x00/c67x00-hcd.h
> @@ -9,16 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> - * MA  02110-1301  USA.
>    */
>
>   #ifndef _USB_C67X00_HCD_H
> diff --git a/drivers/usb/c67x00/c67x00-ll-hpi.c b/drivers/usb/c67x00/c67x00-ll-hpi.c
> index a9636f4..7043d17 100644
> --- a/drivers/usb/c67x00/c67x00-ll-hpi.c
> +++ b/drivers/usb/c67x00/c67x00-ll-hpi.c
> @@ -9,16 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> - * MA  02110-1301  USA.
>    */
>
>   #include<asm/byteorder.h>
> diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
> index a03fbc1..ae977dc 100644
> --- a/drivers/usb/c67x00/c67x00-sched.c
> +++ b/drivers/usb/c67x00/c67x00-sched.c
> @@ -9,16 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> - * MA  02110-1301  USA.
>    */
>
>   #include<linux/kthread.h>
> diff --git a/drivers/usb/c67x00/c67x00.h b/drivers/usb/c67x00/c67x00.h
> index a26e9de..9c165d2 100644
> --- a/drivers/usb/c67x00/c67x00.h
> +++ b/drivers/usb/c67x00/c67x00.h
> @@ -9,16 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> - * MA  02110-1301  USA.
>    */
>
>   #ifndef _USB_C67X00_H
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index dac7676..9d690de 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -17,15 +17,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>    */
>
>   #undef DEBUG
> diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
> index 9eca405..9092be1 100644
> --- a/drivers/usb/class/usblp.c
> +++ b/drivers/usb/class/usblp.c
> @@ -36,15 +36,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 37518df..14d67bb 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -10,15 +10,6 @@
>    *      the Free Software Foundation; either version 2 of the License, or
>    *      (at your option) any later version.
>    *
> - *      This program is distributed in the hope that it will be useful,
> - *      but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *      GNU General Public License for more details.
> - *
> - *      You should have received a copy of the GNU General Public License
> - *      along with this program; if not, write to the Free Software
> - *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - *
>    *  This file implements the usbfs/x/y files, where
>    *  x is the bus number and y the device number.
>    *
> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> index ce22f4a..f30abba 100644
> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index ace9f84..1cf324e 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -11,15 +11,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
> index 40a844c..f4ab75a 100644
> --- a/drivers/usb/host/ehci-dbg.c
> +++ b/drivers/usb/host/ehci-dbg.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* this file is part of ehci-hcd.c */
> diff --git a/drivers/usb/host/ehci-fsl.h b/drivers/usb/host/ehci-fsl.h
> index 4918062..42356e5 100644
> --- a/drivers/usb/host/ehci-fsl.h
> +++ b/drivers/usb/host/ehci-fsl.h
> @@ -5,15 +5,6 @@
>    * under  the terms of  the GNU General  Public License as published by the
>    * Free Software Foundation;  either version 2 of the  License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the  GNU General Public License along
> - * with this program; if not, write  to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>   #ifndef _EHCI_FSL_H
>   #define _EHCI_FSL_H
> diff --git a/drivers/usb/host/ehci-grlib.c b/drivers/usb/host/ehci-grlib.c
> index 93b230d..586024f 100644
> --- a/drivers/usb/host/ehci-grlib.c
> +++ b/drivers/usb/host/ehci-grlib.c
> @@ -14,15 +14,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index 9ff9abc..e7c9557 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -9,15 +9,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 88cfb8f..6a174d4 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* this file is part of ehci-hcd.c */
> diff --git a/drivers/usb/host/ehci-lpm.c b/drivers/usb/host/ehci-lpm.c
> index 2111627..11448e5 100644
> --- a/drivers/usb/host/ehci-lpm.c
> +++ b/drivers/usb/host/ehci-lpm.c
> @@ -5,15 +5,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>
>   /* this file is part of ehci-hcd.c */
> diff --git a/drivers/usb/host/ehci-mem.c b/drivers/usb/host/ehci-mem.c
> index 12f70c3..9c6714a 100644
> --- a/drivers/usb/host/ehci-mem.c
> +++ b/drivers/usb/host/ehci-mem.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* this file is part of ehci-hcd.c */
> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index 0c058be..50e74c6 100644
> --- a/drivers/usb/host/ehci-mxc.c
> +++ b/drivers/usb/host/ehci-mxc.c
> @@ -6,15 +6,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/platform_device.h>
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 1102ce6..b189fc2 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -7,15 +7,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef CONFIG_PCI
> diff --git a/drivers/usb/host/ehci-ps3.c b/drivers/usb/host/ehci-ps3.c
> index 64626a7..1c872da 100644
> --- a/drivers/usb/host/ehci-ps3.c
> +++ b/drivers/usb/host/ehci-ps3.c
> @@ -7,15 +7,6 @@
>    *  This program is free software; you can redistribute it and/or modify
>    *  it under the terms of the GNU General Public License as published by
>    *  the Free Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - *
> - *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>    */
>
>   #include<asm/firmware.h>
> diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
> index 0917e3a..5ac7182 100644
> --- a/drivers/usb/host/ehci-q.c
> +++ b/drivers/usb/host/ehci-q.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* this file is part of ehci-hcd.c */
> diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
> index 6c9fbe3..a1fb028 100644
> --- a/drivers/usb/host/ehci-sched.c
> +++ b/drivers/usb/host/ehci-sched.c
> @@ -6,15 +6,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* this file is part of ehci-hcd.c */
> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> index a64d6d6..12c87d7 100644
> --- a/drivers/usb/host/ehci-xilinx-of.c
> +++ b/drivers/usb/host/ehci-xilinx-of.c
> @@ -13,16 +13,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - *
>    */
>
>   #include<linux/signal.h>
> diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
> index 989e0a8..7dc71a8 100644
> --- a/drivers/usb/host/ehci.h
> +++ b/drivers/usb/host/ehci.h
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef __LINUX_EHCI_HCD_H
> diff --git a/drivers/usb/host/imx21-dbg.c b/drivers/usb/host/imx21-dbg.c
> index 6d75334..8b2f4ed 100644
> --- a/drivers/usb/host/imx21-dbg.c
> +++ b/drivers/usb/host/imx21-dbg.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* this file is part of imx21-hcd.c */
> diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
> index af05718..528e089 100644
> --- a/drivers/usb/host/imx21-hcd.c
> +++ b/drivers/usb/host/imx21-hcd.c
> @@ -10,15 +10,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>
> diff --git a/drivers/usb/host/imx21-hcd.h b/drivers/usb/host/imx21-hcd.h
> index 87b29fd..8a41687 100644
> --- a/drivers/usb/host/imx21-hcd.h
> +++ b/drivers/usb/host/imx21-hcd.h
> @@ -10,15 +10,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef __LINUX_IMX21_HCD_H__
> diff --git a/drivers/usb/host/ohci-jz4740.c b/drivers/usb/host/ohci-jz4740.c
> index 931d588..31f99bd 100644
> --- a/drivers/usb/host/ohci-jz4740.c
> +++ b/drivers/usb/host/ohci-jz4740.c
> @@ -5,11 +5,6 @@
>    *  under  the terms of the GNU General  Public License as published by the
>    *  Free Software Foundation;  either version 2 of the License, or (at your
>    *  option) any later version.
> - *
> - *  You should have received a copy of the  GNU General Public License along
> - *  with this program; if not, write  to the Free Software Foundation, Inc.,
> - *  675 Mass Ave, Cambridge, MA 02139, USA.
> - *
>    */
>
>   #include<linux/platform_device.h>
> diff --git a/drivers/usb/host/ohci-ps3.c b/drivers/usb/host/ohci-ps3.c
> index 7009504..81be176 100644
> --- a/drivers/usb/host/ohci-ps3.c
> +++ b/drivers/usb/host/ohci-ps3.c
> @@ -7,15 +7,6 @@
>    *  This program is free software; you can redistribute it and/or modify
>    *  it under the terms of the GNU General Public License as published by
>    *  the Free Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - *
> - *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>    */
>
>   #include<asm/firmware.h>
> diff --git a/drivers/usb/host/ohci-sh.c b/drivers/usb/host/ohci-sh.c
> index f47867f..7e0b55d 100644
> --- a/drivers/usb/host/ohci-sh.c
> +++ b/drivers/usb/host/ohci-sh.c
> @@ -8,16 +8,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; version 2 of the License.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>
>   #include<linux/platform_device.h>
> diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
> index 5fbe997..0008fb1 100644
> --- a/drivers/usb/host/oxu210hp-hcd.c
> +++ b/drivers/usb/host/oxu210hp-hcd.c
> @@ -9,15 +9,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
> index 4586369..85163af 100644
> --- a/drivers/usb/host/r8a66597-hcd.c
> +++ b/drivers/usb/host/r8a66597-hcd.c
> @@ -11,16 +11,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; version 2 of the License.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/host/r8a66597.h b/drivers/usb/host/r8a66597.h
> index 25563e9..e30d2fd 100644
> --- a/drivers/usb/host/r8a66597.h
> +++ b/drivers/usb/host/r8a66597.h
> @@ -11,16 +11,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; version 2 of the License.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>
>   #ifndef __R8A66597_H__
> diff --git a/drivers/usb/host/whci/whcd.h b/drivers/usb/host/whci/whcd.h
> index c80c7d9..3dabc22 100644
> --- a/drivers/usb/host/whci/whcd.h
> +++ b/drivers/usb/host/whci/whcd.h
> @@ -6,16 +6,6 @@
>    * This program is free software; you can redistribute it and/or
>    * modify it under the terms of the GNU General Public License version
>    * 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> - * 02110-1301, USA.
>    */
>   #ifndef __WHCD_H
>   #define __WHCD_H
> diff --git a/drivers/usb/host/whci/whci-hc.h b/drivers/usb/host/whci/whci-hc.h
> index 4d4cbc0..084f288 100644
> --- a/drivers/usb/host/whci/whci-hc.h
> +++ b/drivers/usb/host/whci/whci-hc.h
> @@ -6,16 +6,6 @@
>    * This program is free software; you can redistribute it and/or
>    * modify it under the terms of the GNU General Public License version
>    * 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> - * 02110-1301, USA.
>    */
>   #ifndef _WHCI_WHCI_HC_H
>   #define _WHCI_WHCI_HC_H
> diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
> index 1f50b44..d2fce41 100644
> --- a/drivers/usb/host/xhci-dbg.c
> +++ b/drivers/usb/host/xhci-dbg.c
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include "xhci.h"
> diff --git a/drivers/usb/host/xhci-ext-caps.h b/drivers/usb/host/xhci-ext-caps.h
> index ce5c9e5..b9aec8e 100644
> --- a/drivers/usb/host/xhci-ext-caps.h
> +++ b/drivers/usb/host/xhci-ext-caps.h
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>   /* Up to 16 ms to halt an HC */
>   #define XHCI_MAX_HALT_USEC	(16*1000)
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 0be788c..e83c1c1 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<asm/unaligned.h>
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index fcb7f7e..b87afe3 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/usb.h>
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index cb16de2..961698a 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/pci.h>
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 70cacbb..04af08c 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /*
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 9824761..aff28aa 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/pci.h>
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index d8bbf5c..122b658 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -9,15 +9,6 @@
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef __LINUX_XHCI_HCD_H
> diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
> index 575b56c..045a6e5 100644
> --- a/drivers/usb/image/mdc800.c
> +++ b/drivers/usb/image/mdc800.c
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2 of the License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> - * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> - * for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software Foundation,
> - * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>
> diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
> index 68ab460..b0af640 100644
> --- a/drivers/usb/misc/appledisplay.c
> +++ b/drivers/usb/misc/appledisplay.c
> @@ -9,15 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/misc/rio500_usb.h b/drivers/usb/misc/rio500_usb.h
> index 359abc9..1387a13 100644
> --- a/drivers/usb/misc/rio500_usb.h
> +++ b/drivers/usb/misc/rio500_usb.h
> @@ -6,16 +6,6 @@
>       it under the terms of the GNU General Public License as published by
>       the Free Software Foundation; either version 2 of the License, or
>       (at your option) any later version.
> -
> -    This program is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -    GNU General Public License for more details.
> -
> -    You should have received a copy of the GNU General Public License
> -    along with this program; if not, write to the Free Software
> -    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -
>       ---------------------------------------------------------------------- */
>
>
> diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
> index f63776a..4463697 100644
> --- a/drivers/usb/misc/trancevibrator.c
> +++ b/drivers/usb/misc/trancevibrator.c
> @@ -7,15 +7,6 @@
>    *  it under the terms of the GNU General Public License as published by
>    *  the Free Software Foundation; either version 2 of the License, or
>    *  (at your option) any later version.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - *
> - *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* Standard include files */
> diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
> index 23ac28f..c2edec5 100644
> --- a/drivers/usb/musb/am35x.c
> +++ b/drivers/usb/musb/am35x.c
> @@ -18,12 +18,6 @@
>    * without even the implied warranty of MERCHANTABILITY or
>    * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>    * License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with The Inventra Controller Driver for Linux ; if not,
> - * write to the Free Software Foundation, Inc., 59 Temple Place,
> - * Suite 330, Boston, MA  02111-1307  USA
> - *
>    */
>
>   #include<linux/init.h>
> diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
> index 662ed34..3cbc688 100644
> --- a/drivers/usb/musb/da8xx.c
> +++ b/drivers/usb/musb/da8xx.c
> @@ -18,12 +18,6 @@
>    * without even the implied warranty of MERCHANTABILITY or
>    * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>    * License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with The Inventra Controller Driver for Linux ; if not,
> - * write to the Free Software Foundation, Inc., 59 Temple Place,
> - * Suite 330, Boston, MA  02111-1307  USA
> - *
>    */
>
>   #include<linux/init.h>
> diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
> index 2a2adf6..441c01b 100644
> --- a/drivers/usb/musb/davinci.c
> +++ b/drivers/usb/musb/davinci.c
> @@ -13,12 +13,6 @@
>    * without even the implied warranty of MERCHANTABILITY or
>    * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>    * License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with The Inventra Controller Driver for Linux ; if not,
> - * write to the Free Software Foundation, Inc., 59 Temple Place,
> - * Suite 330, Boston, MA  02111-1307  USA
> - *
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index c5d4c44..8382434 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -17,12 +17,6 @@
>    * without even the implied warranty of MERCHANTABILITY or
>    * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>    * License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with The Inventra Controller Driver for Linux ; if not,
> - * write to the Free Software Foundation, Inc., 59 Temple Place,
> - * Suite 330, Boston, MA  02111-1307  USA
> - *
>    */
>   #include<linux/module.h>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
> index f7e04bf..9fa7e60 100644
> --- a/drivers/usb/musb/ux500.c
> +++ b/drivers/usb/musb/ux500.c
> @@ -8,15 +8,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
> index 07ccea9..dc9a8c8 100644
> --- a/drivers/usb/otg/ab8500-usb.c
> +++ b/drivers/usb/otg/ab8500-usb.c
> @@ -10,16 +10,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - *
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
> index 0f420b2..3d66c37 100644
> --- a/drivers/usb/otg/fsl_otg.c
> +++ b/drivers/usb/otg/fsl_otg.c
> @@ -10,15 +10,6 @@
>    * under  the terms of  the GNU General  Public License as published by the
>    * Free Software Foundation;  either version 2 of the  License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the  GNU General Public License along
> - * with this program; if not, write  to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/otg/fsl_otg.h b/drivers/usb/otg/fsl_otg.h
> index 3f8ef73..ac8e808 100644
> --- a/drivers/usb/otg/fsl_otg.h
> +++ b/drivers/usb/otg/fsl_otg.h
> @@ -4,15 +4,6 @@
>    * under  the terms of  the GNU General  Public License as published by the
>    * Free Software Foundation;  either version 2 of the  License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the  GNU General Public License along
> - * with this program; if not, write  to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include "otg_fsm.h"
> diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
> index 8c28225..9e9b061 100644
> --- a/drivers/usb/otg/isp1301_omap.c
> +++ b/drivers/usb/otg/isp1301_omap.c
> @@ -8,15 +8,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/otg/langwell_otg.c b/drivers/usb/otg/langwell_otg.c
> index f08f784..d202b28 100644
> --- a/drivers/usb/otg/langwell_otg.c
> +++ b/drivers/usb/otg/langwell_otg.c
> @@ -5,16 +5,6 @@
>    * This program is free software; you can redistribute it and/or modify it
>    * under the terms and conditions of the GNU General Public License,
>    * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> - *
>    */
>   /* This driver helps to switch Langwell OTG controller function between host
>    * and peripheral. It works with EHCI driver and Langwell client controller
> diff --git a/drivers/usb/otg/otg_fsm.c b/drivers/usb/otg/otg_fsm.c
> index b0cc422..e91b1dc 100644
> --- a/drivers/usb/otg/otg_fsm.c
> +++ b/drivers/usb/otg/otg_fsm.c
> @@ -10,15 +10,6 @@
>    * under  the terms of  the GNU General  Public License as published by the
>    * Free Software Foundation;  either version 2 of the  License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the  GNU General Public License along
> - * with this program; if not, write  to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/otg/otg_fsm.h b/drivers/usb/otg/otg_fsm.h
> index 0cecf1d..0697675 100644
> --- a/drivers/usb/otg/otg_fsm.h
> +++ b/drivers/usb/otg/otg_fsm.h
> @@ -4,15 +4,6 @@
>    * under  the terms of  the GNU General  Public License as published by the
>    * Free Software Foundation;  either version 2 of the  License, or (at your
>    * option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the  GNU General Public License along
> - * with this program; if not, write  to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #undef DEBUG
> diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
> index cfb5aa7..ff4bf68 100644
> --- a/drivers/usb/otg/twl6030-usb.c
> +++ b/drivers/usb/otg/twl6030-usb.c
> @@ -8,16 +8,6 @@
>    * (at your option) any later version.
>    *
>    * Author: Hema HK<hemahk@ti.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - *
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/otg/ulpi.c b/drivers/usb/otg/ulpi.c
> index 770d799..9bc9745 100644
> --- a/drivers/usb/otg/ulpi.c
> +++ b/drivers/usb/otg/ulpi.c
> @@ -12,15 +12,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
> index f3664d6..56ae3ad 100644
> --- a/drivers/usb/renesas_usbhs/common.c
> +++ b/drivers/usb/renesas_usbhs/common.c
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #include<linux/io.h>
>   #include<linux/module.h>
> diff --git a/drivers/usb/renesas_usbhs/common.h b/drivers/usb/renesas_usbhs/common.h
> index 0aadcb4..3b94d6e 100644
> --- a/drivers/usb/renesas_usbhs/common.h
> +++ b/drivers/usb/renesas_usbhs/common.h
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #ifndef RENESAS_USB_DRIVER_H
>   #define RENESAS_USB_DRIVER_H
> diff --git a/drivers/usb/renesas_usbhs/mod.c b/drivers/usb/renesas_usbhs/mod.c
> index a577f8f..4bb0091 100644
> --- a/drivers/usb/renesas_usbhs/mod.c
> +++ b/drivers/usb/renesas_usbhs/mod.c
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #include<linux/interrupt.h>
>
> diff --git a/drivers/usb/renesas_usbhs/mod.h b/drivers/usb/renesas_usbhs/mod.h
> index 5c845a2..8ab558c 100644
> --- a/drivers/usb/renesas_usbhs/mod.h
> +++ b/drivers/usb/renesas_usbhs/mod.h
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #ifndef RENESAS_USB_MOD_H
>   #define RENESAS_USB_MOD_H
> diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
> index 547486c..37d25fe 100644
> --- a/drivers/usb/renesas_usbhs/mod_gadget.c
> +++ b/drivers/usb/renesas_usbhs/mod_gadget.c
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #include<linux/io.h>
>   #include<linux/module.h>
> diff --git a/drivers/usb/renesas_usbhs/pipe.c b/drivers/usb/renesas_usbhs/pipe.c
> index bc4521c..927e292 100644
> --- a/drivers/usb/renesas_usbhs/pipe.c
> +++ b/drivers/usb/renesas_usbhs/pipe.c
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #include<linux/delay.h>
>   #include<linux/io.h>
> diff --git a/drivers/usb/renesas_usbhs/pipe.h b/drivers/usb/renesas_usbhs/pipe.h
> index 1cca9b7..3d1467d 100644
> --- a/drivers/usb/renesas_usbhs/pipe.h
> +++ b/drivers/usb/renesas_usbhs/pipe.h
> @@ -3,16 +3,6 @@
>    *
>    * Copyright (C) 2011 Renesas Solutions Corp.
>    * Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>    */
>   #ifndef RENESAS_USB_PIPE_H
>   #define RENESAS_USB_PIPE_H
> diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
> index b0a7a9e..ff53370 100644
> --- a/drivers/usb/serial/garmin_gps.c
> +++ b/drivers/usb/serial/garmin_gps.c
> @@ -12,15 +12,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 USA
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
> index 42d0eae..b4d4f8f 100644
> --- a/drivers/usb/storage/alauda.c
> +++ b/drivers/usb/storage/alauda.c
> @@ -20,15 +20,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
> index c844718..ef64347 100644
> --- a/drivers/usb/storage/cypress_atacb.c
> +++ b/drivers/usb/storage/cypress_atacb.c
> @@ -8,15 +8,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
> index ded836b..e73993e 100644
> --- a/drivers/usb/storage/datafab.c
> +++ b/drivers/usb/storage/datafab.c
> @@ -22,15 +22,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /*
> diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
> index a2b5526..c397f16 100644
> --- a/drivers/usb/storage/debug.c
> +++ b/drivers/usb/storage/debug.c
> @@ -31,15 +31,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/cdrom.h>
> diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
> index dbb985d..114824c 100644
> --- a/drivers/usb/storage/debug.h
> +++ b/drivers/usb/storage/debug.h
> @@ -28,15 +28,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef _DEBUG_H_
> diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
> index 31645af..334c43a 100644
> --- a/drivers/usb/storage/ene_ub6250.c
> +++ b/drivers/usb/storage/ene_ub6250.c
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>   #include<linux/jiffies.h>
>   #include<linux/errno.h>
> diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
> index 105d900..667b0a7 100644
> --- a/drivers/usb/storage/initializers.c
> +++ b/drivers/usb/storage/initializers.c
> @@ -24,15 +24,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/errno.h>
> diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initializers.h
> index 529327f..3f4ead1 100644
> --- a/drivers/usb/storage/initializers.h
> +++ b/drivers/usb/storage/initializers.h
> @@ -24,15 +24,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include "usb.h"
> diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
> index 6168596..f323fc8 100644
> --- a/drivers/usb/storage/jumpshot.c
> +++ b/drivers/usb/storage/jumpshot.c
> @@ -23,15 +23,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>    /*
> diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
> index ba1b789..868ab56 100644
> --- a/drivers/usb/storage/karma.c
> +++ b/drivers/usb/storage/karma.c
> @@ -7,15 +7,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
> index 1943be5..34be2ae 100644
> --- a/drivers/usb/storage/onetouch.c
> +++ b/drivers/usb/storage/onetouch.c
> @@ -16,16 +16,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> - *
>    */
>
>   #include<linux/kernel.h>
> diff --git a/drivers/usb/storage/option_ms.c b/drivers/usb/storage/option_ms.c
> index 8946018..6ca9828 100644
> --- a/drivers/usb/storage/option_ms.c
> +++ b/drivers/usb/storage/option_ms.c
> @@ -9,15 +9,6 @@
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/usb.h>
> diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
> index fc310f7..c19f082 100644
> --- a/drivers/usb/storage/protocol.c
> +++ b/drivers/usb/storage/protocol.c
> @@ -31,15 +31,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/highmem.h>
> diff --git a/drivers/usb/storage/protocol.h b/drivers/usb/storage/protocol.h
> index ffc3e2a..73e0fb1 100644
> --- a/drivers/usb/storage/protocol.h
> +++ b/drivers/usb/storage/protocol.h
> @@ -25,15 +25,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef _PROTOCOL_H_
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index 13b8bcd..54ae5f1 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -32,15 +32,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/module.h>
> diff --git a/drivers/usb/storage/scsiglue.h b/drivers/usb/storage/scsiglue.h
> index ffa1cca..3cf812f 100644
> --- a/drivers/usb/storage/scsiglue.h
> +++ b/drivers/usb/storage/scsiglue.h
> @@ -25,15 +25,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef _SCSIGLUE_H_
> diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
> index bcb9a70..feb9aff 100644
> --- a/drivers/usb/storage/sddr09.c
> +++ b/drivers/usb/storage/sddr09.c
> @@ -15,15 +15,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /*
> diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
> index 44dfed7..69a8ff7 100644
> --- a/drivers/usb/storage/sddr55.c
> +++ b/drivers/usb/storage/sddr55.c
> @@ -11,15 +11,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/jiffies.h>
> diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
> index 0b00091..8007ab6 100644
> --- a/drivers/usb/storage/shuttle_usbat.c
> +++ b/drivers/usb/storage/shuttle_usbat.c
> @@ -30,15 +30,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/errno.h>
> diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
> index e8ae21b..21fd5dd 100644
> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -32,15 +32,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/sched.h>
> diff --git a/drivers/usb/storage/transport.h b/drivers/usb/storage/transport.h
> index 242ff5e..647321a 100644
> --- a/drivers/usb/storage/transport.h
> +++ b/drivers/usb/storage/transport.h
> @@ -25,15 +25,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef _TRANSPORT_H_
> diff --git a/drivers/usb/storage/unusual_alauda.h b/drivers/usb/storage/unusual_alauda.h
> index fa3e9ed..e46e210 100644
> --- a/drivers/usb/storage/unusual_alauda.h
> +++ b/drivers/usb/storage/unusual_alauda.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_ALAUDA) || \
> diff --git a/drivers/usb/storage/unusual_cypress.h b/drivers/usb/storage/unusual_cypress.h
> index 2c85530..80b0533 100644
> --- a/drivers/usb/storage/unusual_cypress.h
> +++ b/drivers/usb/storage/unusual_cypress.h
> @@ -5,15 +5,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || \
> diff --git a/drivers/usb/storage/unusual_datafab.h b/drivers/usb/storage/unusual_datafab.h
> index 582a603..1401085 100644
> --- a/drivers/usb/storage/unusual_datafab.h
> +++ b/drivers/usb/storage/unusual_datafab.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_DATAFAB) || \
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 3041a97..f505e58 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -14,15 +14,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   /* IMPORTANT NOTE: This file must be included in another file which does
> diff --git a/drivers/usb/storage/unusual_ene_ub6250.h b/drivers/usb/storage/unusual_ene_ub6250.h
> index 5667f5d..aa1ba2c 100644
> --- a/drivers/usb/storage/unusual_ene_ub6250.h
> +++ b/drivers/usb/storage/unusual_ene_ub6250.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_ENE_UB6250) || \
> diff --git a/drivers/usb/storage/unusual_freecom.h b/drivers/usb/storage/unusual_freecom.h
> index 59a2611..119fa62 100644
> --- a/drivers/usb/storage/unusual_freecom.h
> +++ b/drivers/usb/storage/unusual_freecom.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_FREECOM) || \
> diff --git a/drivers/usb/storage/unusual_isd200.h b/drivers/usb/storage/unusual_isd200.h
> index 14cca0c..e472403 100644
> --- a/drivers/usb/storage/unusual_isd200.h
> +++ b/drivers/usb/storage/unusual_isd200.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_ISD200) || \
> diff --git a/drivers/usb/storage/unusual_jumpshot.h b/drivers/usb/storage/unusual_jumpshot.h
> index 54be78b..54588f5 100644
> --- a/drivers/usb/storage/unusual_jumpshot.h
> +++ b/drivers/usb/storage/unusual_jumpshot.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_JUMPSHOT) || \
> diff --git a/drivers/usb/storage/unusual_karma.h b/drivers/usb/storage/unusual_karma.h
> index 6df0397..dcebe9b 100644
> --- a/drivers/usb/storage/unusual_karma.h
> +++ b/drivers/usb/storage/unusual_karma.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_KARMA) || \
> diff --git a/drivers/usb/storage/unusual_onetouch.h b/drivers/usb/storage/unusual_onetouch.h
> index 0abb819..bc6bb25 100644
> --- a/drivers/usb/storage/unusual_onetouch.h
> +++ b/drivers/usb/storage/unusual_onetouch.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_ONETOUCH) || \
> diff --git a/drivers/usb/storage/unusual_sddr09.h b/drivers/usb/storage/unusual_sddr09.h
> index 59a7e37..8a0651e 100644
> --- a/drivers/usb/storage/unusual_sddr09.h
> +++ b/drivers/usb/storage/unusual_sddr09.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_SDDR09) || \
> diff --git a/drivers/usb/storage/unusual_sddr55.h b/drivers/usb/storage/unusual_sddr55.h
> index fcb7e12..df2ba1f 100644
> --- a/drivers/usb/storage/unusual_sddr55.h
> +++ b/drivers/usb/storage/unusual_sddr55.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_SDDR55) || \
> diff --git a/drivers/usb/storage/unusual_usbat.h b/drivers/usb/storage/unusual_usbat.h
> index 38e79c4..62cc4a4 100644
> --- a/drivers/usb/storage/unusual_usbat.h
> +++ b/drivers/usb/storage/unusual_usbat.h
> @@ -4,15 +4,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #if defined(CONFIG_USB_STORAGE_USBAT) || \
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 0ca0958..1bec8ce 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -34,15 +34,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifdef CONFIG_USB_STORAGE_DEBUG
> diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
> index 7b0f211..b4b0bae 100644
> --- a/drivers/usb/storage/usb.h
> +++ b/drivers/usb/storage/usb.h
> @@ -28,15 +28,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #ifndef _USB_H_
> diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
> index b969279..e1e7c2f 100644
> --- a/drivers/usb/storage/usual-tables.c
> +++ b/drivers/usb/storage/usual-tables.c
> @@ -10,15 +10,6 @@
>    * under the terms of the GNU General Public License as published by the
>    * Free Software Foundation; either version 2, or (at your option) any
>    * later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 675 Mass Ave, Cambridge, MA 02139, USA.
>    */
>
>   #include<linux/kernel.h>


